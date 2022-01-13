emotiondetectionClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
  "emotiondetectionClass",
  inherit = emotiondetectionBase,
  private = list(
    .run = function() {
      # Collect all relevant input data and controls
      data <- self$data
      sentiment_data <- self$options$sentiment_data
      split_var <- self$options$split_var
      chart_type <- self$options$chart_type
      uncombine <- self$options$uncombine
      switch <- self$options$switch
      disp_by_perc <- self$options$disp_by_perc
      horizontal_bars <- self$options$horizontal_bars
      palette_colors <- self$options$palette_colors
      value_labels <- self$options$value_labels
      enable_component_axis <- self$options$enable_component_axis
      component_axis <- self$options$component_axis
      custom_img_size <- self$options$custom_img_size
      custom_width <- self$options$custom_width
      custom_height <- self$options$custom_height
      
      # Function for printing warnings on the screen.
      print_warning <- function(string) {
        self$results$text$setVisible(TRUE)
        self$results$text$setContent(stringi::stri_wrap(string,
                                                        width = 80,
                                                        prefix = "<br>",
                                                        initial = ""))
      }
      
      # Check if there is data to analyze. If none, show welcome message.
      if (is.null(sentiment_data)) {
        print_warning(paste("Thanks for installing Not a Data Vis! Try dragging some",
                            "variables containing open text data into the list box, and",
                            "play around with the UI 'til you get what you need."))
        return()
      }
      
      # Now, even though the user has some variables in Sentiment Data, they might be
      # empty, leaving no variables to analyze.
      if (nrow(data) == 0) {
        print_warning(paste("There is no data to analyze! Are you sure you've picked",
                            "the correct dataset columns for the Sentiment Data list box?"))
        return()
      }
      
      # Check for Independent Variable input.
      if (!is.null(split_var)) {
        # Remove rows where IV is missing.
        data <- tidyr::drop_na(data, split_var)
        # Convert data to long format. To do this, first standardize the Independent Variable name.
        # The resulting data frame will also have rows with missing values removed.
        names(data)[names(data) == split_var] <- "split_var"
        data <- data %>%
          tidyr::gather(key = "prompt", value = "response", -split_var, na.rm = TRUE)
      } else {
        data <- data %>%
          tidyr::gather(key = "prompt", value = "response", na.rm = TRUE)
      }
      
      # It's possible that no data will be left after removing missing values, although it
      # shouldn't happen with the correct data inspection on the user's part.
      if (nrow(data) == 0) {
        print_warning(paste("It seems that removing missing values from your data variables",
                            "left no data to analyze. Make sure you're choosing the correct",
                            "dataset columns!"))
        return()
      }
      
      # Extract emotion counts per sentence.
      emotion_data <- data$response %>%
        sentimentr::get_sentences() %>%
        sentimentr::emotion()
      
      # Sum emotion counts by groups according to user input.
      group_vars <- c()
      if (uncombine) {
        emotion_data <- emotion_data %>%
          dplyr::mutate(prompt = data$prompt[element_id])
        group_vars <- c(group_vars, "prompt")
      }
      if (!is.null(split_var)) {
        emotion_data <- emotion_data %>%
          dplyr::mutate(split_var_values = data$split_var[element_id])
        group_vars <- c(group_vars, "split_var_values")
      }
      group_vars <- c(group_vars, "emotion_type")
      data <- emotion_data %>%
        dplyr::group_by_at(group_vars) %>%
        dplyr::summarise(freq = sum(emotion_count))
      
      # Remove negated emotion types, since we aren't really interested in that.
      data <- data %>%
        subset(!endsWith(as.character(emotion_type), "_negated"))
      
      # If percentage scale is enabled, convert sums into percentages.
      if (disp_by_perc) {
        data <- data %>%
          dplyr::mutate(freq = freq / sum(freq))
      }
      
      # To drop zero values when plotting, remove the rows where freq = 0.
      data <- data[data$freq != 0, ]
      
      # The analysis shouldn't run in the possible case that all rows
      # get deleted from the previous action.
      if(nrow(data) == 0) {
        print_warning(paste("The analysis detected no emotions from your dataset. Maybe you're",
                            "trying to analyze data written in another language. This analysis",
                            "can only detect emotions within the English language. If that's",
                            "inconvenient for you, sorry!"))
        return()
      }
      
      # Data is ready for plotting.
      image <- self$results$plot
      image$setState(data)
      image$setVisible(TRUE)
      
      # Time to set image size. If custom image size is turned on, use the user-defined image size.
      if (custom_img_size) {
        image$setSize(custom_width, custom_height)
        return()
      }
      
      # Since image size is not custom, proceed to the automatic algorithm.
      # Drop the frequency column. Changes we make to "data" from this point won't affect
      # the data passed to the .plot function.
      data$freq <- NULL
      
      conditions <- private$.get_conditions()
      
      if (conditions$default) {
        
        num_emotions <- nrow(data)
        num_groups <- 1
        num_facets <- 1
        strip_size <- 0
        
      } else if (conditions$uncombined) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- nrow(data)
        num_facets <- 1
        strip_size <- 0
        
      } else if (conditions$switched_uncombined) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- 1
        num_facets <- nrow(data)
        strip_size <- 20
        
      } else if (conditions$grouped) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- nrow(data)
        num_facets <- 1
        strip_size <- 0
        
      } else if (conditions$grouped_uncombined) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- length(unique(data$split_var_values))
        num_facets <- length(unique(data$prompt))
        strip_size <- 20
        
        
      } else if (conditions$grouped_switched) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- 1
        num_facets <- nrow(data)
        strip_size <- 20
        
      } else if (conditions$grouped_switched_uncombined) {
        
        data <- data %>%
          dplyr::summarise(emotions_per_group = dplyr::n())
        num_emotions <- max(data$emotions_per_group)
        num_groups <- length(unique(data$prompt))
        num_facets <- length(unique(data$split_var_values))
        strip_size <- 20
        
      }
      
      axis_size <- 35
      legend_size <- ceiling(num_emotions / 5) * 18
      if (chart_type == "dodge") {
        bar_size <- 23
        bar_space <- floor(0.1 * bar_size)
        group_size <- num_emotions * (bar_size + bar_space) - bar_space
        group_space <- bar_size + 1
      } else {
        group_size <- 37
        group_space <- floor(0.1 * group_size)
      }
      chart_size <- num_groups * (group_size + group_space) - group_space
      chart_margins <- 3 * group_space
      
      if (!horizontal_bars) {
        img_width <- axis_size + min(num_facets, 2) * (chart_size + chart_margins + 5) - 5
        img_height <- legend_size * 3 / 2 + (strip_size + 330) * ceiling(num_facets / 2) + axis_size
      } else {
        img_width <- 550
        img_height <- legend_size * 3 / 2 +
          (strip_size + chart_size + chart_margins) * ceiling(num_facets / 2) +
          axis_size
      }
      
      image$setSize(max(330, img_width), img_height)
      
    },
    .get_conditions = function() {
      
      # Collect all relevent input controls.
      split_var <- self$options$split_var
      uncombine <- self$options$uncombine
      switch <- self$options$switch
      
      # Return list of Boolean values indicating the state of UI options.
      return(list(default = is.null(split_var) && !switch && !uncombine,
                  uncombined = is.null(split_var) && !switch && uncombine,
                  switched_uncombined = is.null(split_var) && switch && uncombine,
                  grouped = !is.null(split_var) && !switch && !uncombine,
                  grouped_uncombined = !is.null(split_var) && !switch && uncombine,
                  grouped_switched = !is.null(split_var) && switch && !uncombine,
                  grouped_switched_uncombined = !is.null(split_var) && switch && uncombine))
    },
    .plot = function(image, ...) {
      
      # Check if the plot function should run.
      data <- image$state
      if (is.null(data)) return(FALSE)
      
      # Collect all relevant input controls.
      sentiment_data <- self$options$sentiment_data
      split_var <- self$options$split_var
      chart_type <- self$options$chart_type
      uncombine <- self$options$uncombine
      switch <- self$options$switch
      disp_by_perc <- self$options$disp_by_perc
      horizontal_bars <- self$options$horizontal_bars
      palette_colors <- self$options$palette_colors
      value_labels <- self$options$value_labels
      enable_component_axis <- self$options$enable_component_axis
      component_axis <- self$options$component_axis
      custom_img_size <- self$options$custom_img_size
      custom_width <- self$options$custom_width
      custom_height <- self$options$custom_height
      
      # Determine plot aesthetics based on user input and place the base ggplot layer.
      conditions <- private$.get_conditions()
      
      if (conditions$default) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = "", y = freq, fill = emotion_type))
        
      } else if (conditions$uncombined) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = prompt, y = freq, fill = emotion_type))
        x_title <- component_axis
        
      } else if (conditions$switched_uncombined) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = "", y = freq, fill = emotion_type)) +
          ggplot2::facet_wrap(~ prompt, ncol = 2)
        
      } else if (conditions$grouped) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = split_var_values, y = freq, fill = emotion_type))
        x_title <- split_var
        
      } else if (conditions$grouped_uncombined) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = split_var_values, y = freq, fill = emotion_type)) +
          ggplot2::facet_wrap(~ prompt, ncol = 2)
        x_title <- split_var
        
      } else if (conditions$grouped_switched) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = "", y = freq, fill = emotion_type)) +
          ggplot2::facet_wrap(~ split_var_values, ncol = 2)
        
      } else if (conditions$grouped_switched_uncombined) {
        
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = prompt, y = freq, fill = emotion_type)) +
          ggplot2::facet_wrap(~ split_var_values, ncol = 2)
        x_title <- component_axis
        
      }
      
      # Determine the positioning of bars.
      if (chart_type == "dodge") {
        pos <- ggplot2::position_dodge2(padding = 0.1, preserve = "single")
      } else pos <- "stack"
      
      # Add the bar chart layer.
      plot <- plot +
        ggplot2::geom_bar(stat = "identity", position = pos)
      
      # If the chart should show numeric labels on the bars, add a text layer.
      if (value_labels) {
        as_percentage <- function(vect) {
          return(scales::label_percent(1)(round(vect, 2)))
        }
        if (chart_type == "dodge") {
          label_pos <- ggplot2::position_dodge2(width = 0.9, preserve = "single")
          aesthetics <- ggplot2::aes(label = if (disp_by_perc) as_percentage(freq) else freq,
                                     y = freq + max(freq) * (if (horizontal_bars) 0.05 else 0.03))
        } else {
          label_pos <- ggplot2::position_stack(vjust = 0.5)
          aesthetics <- ggplot2::aes(label = if (disp_by_perc) as_percentage(freq) else freq)
        }
        plot <- plot +
          geom_text(aesthetics, position = label_pos)
      }
      
      # Implement the color palette.
      pal <- length(unique(data$emotion_type)) %>%
        colorRampPalette(RColorBrewer::brewer.pal(n = 9, name = palette_colors))() %>%
        colorspace::darken(amount = 0.1, space = "combined")
      
      # Add all elements and overall look of the plot.
      plot <- plot +
        ggplot2::scale_fill_manual(values = pal) +
        ggplot2::ylab("Frequency") +
        ggpubr::theme_pubclean() +
        ggplot2::theme(legend.title = ggplot2::element_blank()) +
        ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff"))
      if (enable_component_axis) {
        plot <- plot +
          ggplot2::xlab(x_title)
      } else if (horizontal_bars) {
        plot <- plot +
          ggplot2::theme(axis.title.y = ggplot2::element_blank())
      } else {
        plot <- plot +
          ggplot2::theme(axis.title.x = ggplot2::element_blank())
      }
      if (horizontal_bars) {
        plot <- plot +
          ggplot2::coord_flip()
      }
      
      # Finally, print the plot.
      print(plot)
      return(TRUE)
      
    }
  )
)