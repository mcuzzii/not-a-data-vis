sentimentscoresClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
  "sentimentscoresClass",
  inherit = sentimentscoresBase,
  private = list(
    .run = function() {
      
      # Collect all input data and controls.
      data <- self$data
      sentiment_data <- self$options$sentiment_data
      iv <- self$options$iv
      chart_type <- self$options$chart_type
      averaging_method <- self$options$averaging_method
      scoring_method <- self$options$scoring_method
      uncombine <- self$options$uncombine
      split_by_iv <- self$options$split_by_iv
      facet_mode <- self$options$facet_mode
      add_graphics <- self$options$add_graphics
      palette_colors <- self$options$palette_colors
      custom_img_size <- self$options$custom_img_size
      custom_width <- self$options$custom_width
      custom_height <- self$options$custom_height
      
      # Function for printing warnings on the screen.
      print_warning = function(string) {
        self$results$text$setVisible(TRUE)
        self$results$text$setContent(stringi::stri_wrap(string,
                                                        width = 80,
                                                        prefix = "<br>",
                                                        initial = ""))
      }
      
      # Assign the plot results to variable "image". This variable will also carry the
      # processed data so it will be accessible from the .plot function. However, if the
      # analysis shouldn't run, this will carry a Boolean "false" value.
      image <- self$results$plot
      
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
      
      # If chart type is scatter plots, warn the user that an independent variable is
      # required.
      if (chart_type == "ct_scatterplots" && is.null(iv)) {
        print_warning(paste("Scatter plots allow you to check whether sentiment data",
                            "correlates with continuous data, or other sentiment",
                            "variables. Insert any continuous variable or open text data",
                            "into the Independent Variables list box."))
        return()
      }
      
      empty_check <- function() {
        # It's possible that no data will be left after removing missing values, although it
        # shouldn't happen with the correct data inspection on the user's part.
        if (nrow(data) == 0) {
          print_warning(paste("It seems that removing missing values from your data variables",
                              "left no data to analyze. Make sure you're choosing the correct",
                              "dataset columns!"))
          return(TRUE)
        }
        return(FALSE)
      }
      
      # Check for Independent Variable input.
      if (!is.null(iv)) {
        # Remove rows where IV is missing.
        data <- tidyr::drop_na(data, iv)
        if (empty_check()) return()
        names(data)[names(data) == iv] <- "iv"
        # Store the IV column somewhere else first, as it will be removed from the data frame.
        iv_vector <- data$iv
        data$iv <- NULL
      }
      
      # Uniquely identify rows
      data$row_num <- seq.int(nrow(data))
      
      # Convert data to long format, preserving original row numbers.
      data <- data %>% 
        tidyr::gather(key = "prompt", value = "response", -row_num, na.rm = TRUE)
      
      if (empty_check()) return()
      
      # Check if input variables in "Sentiment Data" are in the correct format.
      valid_flag <- TRUE
      for (var in unique(data$prompt)) {
        var_data_type <- private$.data_type(subset(data, prompt == var)$response)
        if (var_data_type != "sentiment") {
          valid_flag <- FALSE
          break
        }
      }
      if (!valid_flag) {
        print_warning("Sentiment Data variables must be of open text format!")
        return()
      }
      
      if (!is.null(iv)) {
        iv_data_type <- private$.data_type(iv_vector)
        if (chart_type == "ct_scatterplots" && iv_data_type == "factor") {
          print_warning(paste("Independent variable must be of either a continuous or",
                                       "open text data type!"))
          return()
        } else if (chart_type != "ct_scatterplots" && iv_data_type != "factor") {
          print_warning("Independent variable must be of a categorical data type!")
          return()
        }
      }
      
      # All data processing will occur in the .plot function. This is because Jamovi gets buggy
      # when the .run() function takes too long whereas large datasets can easily lengthen the
      # run time.
      args <- list(data = data)
      if (!is.null(iv)) args$iv_vector <- iv_vector
      image$setState(args)
      image$setVisible(TRUE)
      
      # Determine image size.
      if (custom_img_size) {
        image$setSize(custom_width, custom_height)
        return()
      }
      
      # Since image size was not customized, proceed with the automatic algorithm.
      conditions <- private$.get_conditions()
      
      box_width <- 25
      upper_ridge <- 100
      lower_ridge <- 60
      legend_row_width <- 25
      strip_size <- 25
      axis_size <- 50
      scatterplot_size <- 350
      
      if (conditions$box_uncombined_iv_switched_facets) {
        
        blank_spaces <- 25
        group_size <- box_width * length(unique(iv_vector))
        n_panel_rows <- ceiling(length(unique(data$prompt)) / 2)
        img_height <- legend_size +
          blank_spaces +
          n_panel_rows * (strip_size + group_size) +
          axis_size
        
      } else if (conditions$box_uncombined_iv_switched) {
        
        legend_size <- legend_row_width * ceiling(length(unique(iv_vector)) / 5)
        group_size <- box_width * length(unique(iv_vector))
        blank_spaces <- 25 +
          (length(unique(data$prompt)) - 1) * round(0.4 * group_size, digits = 0)
        img_height <- legend_size +
          length(unique(data$prompt)) * group_size +
          blank_spaces +
          axis_size
        
      } else if (conditions$box_uncombined_iv_facets) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        group_size <- box_width * length(unique(data$prompt))
        n_panel_rows <- ceiling(length(unique(iv_vector)) / 2)
        blank_spaces <- 25
        img_height <- legend_size +
          blank_spaces +
          n_panel_rows * (strip_size + group_size) +
          axis_size
        
      } else if (conditions$box_uncombined_iv) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        group_size <- box_width * length(unique(data$prompt))
        blank_spaces <- 25 +
          (length(unique(iv_vector)) - 1) * round(0.4 * group_size, digits = 0)
        img_height <- legend_size +
          length(unique(iv_vector)) * group_size +
          blank_spaces +
          axis_size
        
      } else if (conditions$box_uncombined_switched_facets) {
        
        n_panel_rows <- ceiling(length(unique(data$prompt)) / 2)
        img_height <- n_panel_rows * (strip_size + box_width) + axis_size
        
      } else if (conditions$box_uncombined_switched) {
        
        blank_spaces <- (length(unique(data$prompt)) - 1) *
          round(0.4 * box_width, digits = 0)
        img_height <- length(unique(data$prompt)) * box_width + blank_spaces + axis_size
        
      } else if (conditions$box_uncombined) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        group_size <- box_width * length(unique(data$prompt))
        blank_spaces <- 25
        img_height <- legend_size + blank_spaces + group_size + axis_size
        
      } else if (conditions$box_iv_switched) {
        
        legend_size <- legend_row_width * ceiling(length(unique(iv_vector)) / 5)
        group_size <- box_width * length(unique(iv_vector))
        blank_spaces <- 25
        img_height <- legend_size + blank_spaces + group_size + axis_size
        
      } else if (conditions$box_iv_facets) {
        
        n_panel_rows <- ceiling(length(unique(iv_vector)) / 2)
        img_height <- n_panel_rows * (strip_size + box_width) + axis_size
        
      } else if (conditions$box_iv) {
        
        blank_spaces <- (length(unique(iv_vector)) - 1) *
          round(0.4 * box_width, digits = 0)
        img_height <- length(unique(iv_vector)) * box_width + blank_spaces + axis_size
        
      } else if (conditions$box) img_height <- box_width + axis_size
      else if (conditions$density_uncombined_iv_switched_facets) {
        
        legend_size <- legend_row_width * ceiling(length(unique(iv_vector)) / 5)
        n_panel_rows <- ceiling(length(unique(data$prompt)) / 2)
        blank_spaces <- 25
        img_height <- legend_size +
          blank_spaces +
          n_panel_rows * (strip_size + upper_ridge) +
          axis_size
        
      } else if (conditions$density_uncombined_iv_switched) {
        
        legend_size <- legend_row_width * ceiling(length(unique(iv_vector)) / 5)
        blank_spaces <- 25
        img_height <- legend_size +
          blank_spaces +
          upper_ridge +
          (length(unique(data$prompt)) - 1) * lower_ridge +
          axis_size
        
      } else if (conditions$density_uncombined_iv_facets) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        n_panel_rows <- ceiling(length(unique(iv_vector)) / 2)
        blank_spaces <- 25
        img_height <- legend_size +
          blank_spaces +
          n_panel_rows * (strip_size + upper_ridge) +
          axis_size
        
      } else if (conditions$density_uncombined_iv) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        blank_spaces <- 25
        img_height <- legend_size +
          blank_spaces +
          upper_ridge +
          (length(unique(iv_vector)) - 1) * lower_ridge +
          axis_size
        
      } else if (conditions$density_uncombined_switched_facets) {
        
        n_panel_rows <- ceiling(length(unique(data$prompt)) / 2)
        img_height <- n_panel_rows * (strip_size + upper_ridge) + axis_size
        
      } else if (conditions$density_uncombined_switched) {
        
        img_height <- upper_ridge +
          (length(unique(data$prompt)) - 1) * lower_ridge +
          axis_size
        
      } else if (conditions$density_uncombined) {
        
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        blank_spaces <- 25
        img_height <- legend_size + blank_spaces + upper_ridge + axis_size
        
      } else if (conditions$density_iv_switched) {
        
        legend_size <- legend_row_width * ceiling(length(unique(iv_vector)) / 5)
        blank_spaces <- 25
        img_height <- legend_size + blank_spaces + upper_ridge + axis_size
        
      } else if (conditions$density_iv_facets) {
        
        n_panel_rows <- ceiling(length(unique(iv_vector)) / 2)
        img_height <- n_panel_rows * (strip_size + upper_ridge) + axis_size
        
      } else if (conditions$density_iv) {
        
        img_height <- upper_ridge +
          (length(unique(iv_vector)) - 1) * lower_ridge +
          axis_size
        
      } else if (conditions$density) img_height <- upper_ridge + axis_size
      else if (conditions$scatterplot_uncombined_facets) {
        
        n_panel_rows <- ceiling(length(unique(data$prompt)) / 2)
        img_height <- n_panel_rows * (strip_size + scatterplot_size / 2) +
          axis_size
        
      } else if (conditions$scatterplot_uncombined) {
        
        blank_spaces <- 25
        legend_size <- legend_row_width * ceiling(length(unique(data$prompt)) / 5)
        img_height <- legend_size + blank_spaces + scatterplot_size + axis_size
        
      } else if (conditions$scatterplot) img_height <- scatterplot_size + axis_size
      
      image$setSize(550, img_height)
      
    },
    .data_type = function(variable_vector) {
      if (is.numeric(variable_vector)) return("numeric")
      summary <- as.data.frame(table(variable_vector)) %>% 
        dplyr::group_by(Freq) %>%
        dplyr::summarise(freq_of_freq = dplyr::n())
      if (1 %in% summary$Freq) {
        freq_unique_values <- summary[[which(summary$Freq == 1), "freq_of_freq"]]
        if (freq_unique_values / length(variable_vector) > 0.75) return("sentiment")
      }
      return("factor")
    },
    .get_conditions = function() {
      
      # Collect all relevant option values.
      chart_type <- self$options$chart_type
      uncombine <- self$options$uncombine
      iv <- self$options$iv
      split_by_iv <- self$options$split_by_iv
      facet_mode <- self$options$facet_mode
      
      # Return a list of Boolean variables containing all possible UI combinations.
      return(list(box_uncombined_iv_switched_facets = chart_type == "ct_boxplots" &&
                    uncombine &&
                    !is.null(iv) &&
                    split_by_iv &&
                    facet_mode,
                  box_uncombined_iv_switched = chart_type == "ct_boxplots" &&
                    uncombine &&
                    !is.null(iv) &&
                    split_by_iv &&
                    !facet_mode,
                  box_uncombined_iv_facets = chart_type == "ct_boxplots" &&
                    uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    facet_mode,
                  box_uncombined_iv = chart_type == "ct_boxplots" &&
                    uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    !facet_mode,
                  box_uncombined_switched_facets = chart_type == "ct_boxplots" &&
                    uncombine &&
                    is.null(iv) &&
                    split_by_iv &&
                    facet_mode,
                  box_uncombined_switched = chart_type == "ct_boxplots" &&
                    uncombine &&
                    is.null(iv) &&
                    split_by_iv &&
                    !facet_mode,
                  box_uncombined = chart_type == "ct_boxplots" &&
                    uncombine &&
                    is.null(iv) &&
                    !split_by_iv,
                  box_iv_switched = chart_type == "ct_boxplots" &&
                    !uncombine &&
                    !is.null(iv) &&
                    split_by_iv,
                  box_iv_facets = chart_type == "ct_boxplots" &&
                    !uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    facet_mode,
                  box_iv = chart_type == "ct_boxplots" &&
                    !uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    !facet_mode,
                  box = chart_type == "ct_boxplots" &&
                    !uncombine &&
                    is.null(iv),
                  density_uncombined_iv_switched_facets = chart_type == "ct_density" &&
                    uncombine &&
                    !is.null(iv) &&
                    split_by_iv &&
                    facet_mode,
                  density_uncombined_iv_switched = chart_type == "ct_density" &&
                    uncombine &&
                    !is.null(iv) &&
                    split_by_iv &&
                    !facet_mode,
                  density_uncombined_iv_facets = chart_type == "ct_density" &&
                    uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    facet_mode,
                  density_uncombined_iv = chart_type == "ct_density" &&
                    uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    !facet_mode,
                  density_uncombined_switched_facets = chart_type == "ct_density" &&
                    uncombine &&
                    is.null(iv) &&
                    split_by_iv &&
                    facet_mode,
                  density_uncombined_switched = chart_type == "ct_density" &&
                    uncombine &&
                    is.null(iv) &&
                    split_by_iv &&
                    !facet_mode,
                  density_uncombined = chart_type == "ct_density" &&
                    uncombine &&
                    is.null(iv) &&
                    !split_by_iv,
                  density_iv_switched = chart_type == "ct_density" &&
                    !uncombine &&
                    !is.null(iv) &&
                    split_by_iv,
                  density_iv_facets = chart_type == "ct_density" &&
                    !uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    facet_mode,
                  density_iv = chart_type == "ct_density" &&
                    !uncombine &&
                    !is.null(iv) &&
                    !split_by_iv &&
                    !facet_mode,
                  density = chart_type == "ct_density" &&
                    !uncombine &&
                    is.null(iv),
                  scatterplot_uncombined_facets = chart_type == "ct_scatterplots" &&
                    uncombine &&
                    facet_mode,
                  scatterplot_uncombined = chart_type == "ct_scatterplots" &&
                    uncombine &&
                    !facet_mode,
                  scatterplot = chart_type == "ct_scatterplots" &&
                    !uncombine &&
                    !facet_mode))
      
    },
    .plot = function(image, ...) {
      
      data <- image$state$data
      if (is.null(data)) return(FALSE)
      
      # Collect all input controls.
      sentiment_data <- self$options$sentiment_data
      iv <- self$options$iv
      iv_vector <- image$state$iv_vector
      chart_type <- self$options$chart_type
      averaging_method <- self$options$averaging_method
      scoring_method <- self$options$scoring_method
      uncombine <- self$options$uncombine
      split_by_iv <- self$options$split_by_iv
      facet_mode <- self$options$facet_mode
      add_graphics <- self$options$add_graphics
      palette_colors <- self$options$palette_colors
      custom_img_size <- self$options$custom_img_size
      custom_width <- self$options$custom_width
      custom_height <- self$options$custom_height
      
      # Determine which averaging function to use.
      ave_func <- switch(averaging_method,
                         default_averaging = sentimentr::average_mean,
                         courtesy_reduction = sentimentr::average_weighted_mixed_sentiment,
                         neutrality_reduction = sentimentr::average_downweighted_zero)
      
      # Check validity of Independent Variable input, if any, and process it if valid.
      if (!is.null(iv)) {
        iv_data_type <- private$.data_type(iv_vector)
        if (chart_type == "ct_scatterplots" && iv_data_type == "sentiment") {
          # Calculate sentiment scores for the open text Independent Variable.
          iv_sentiment <- as.character(iv_vector) %>%
            sentimentr::get_sentences() %>%
            sentimentr::sentiment_by(averaging.function = ave_func)
          data <- data %>%
            dplyr::mutate(iv_values = as.numeric(iv_sentiment$ave_sentiment[row_num]))
        } else {
          # In this case, chart type must be scatter plots and IV must be continuous
          # OR chart type is not scatter plots and IV is a factor, both of which are
          # coherent circumstances for the analysis. Convert it to appropriate data
          # type and mutate it into the data frame.
          data <- data %>%
            dplyr::mutate(iv_values = iv_vector[row_num])
        }
      }
      
      # Calculate the sentiment scores of the Sentiment Data variables according to user input
      # and finalize for plotting.
      if (scoring_method == "by_sentence") {
        sentiment_scores <- data$response %>%
          sentimentr::get_sentences() %>%
          sentimentr::sentiment()
        if(!is.null(iv)) {
          data <- sentiment_scores %>%
            dplyr::mutate(prompt = data$prompt[element_id],
                          iv_values = data$iv_values[element_id])
        } else {
          data <- sentiment_scores %>%
            dplyr::mutate(prompt = data$prompt[element_id])
        }
      } else if (scoring_method == "by_cell") {
        sentiment_scores <- data$response %>%
          sentimentr::get_sentences() %>%
          sentimentr::sentiment_by(averaging.function = ave_func) %>%
          dplyr::rename(sentiment = ave_sentiment)
        if (!is.null(iv)) {
          data <- sentiment_scores %>%
            dplyr::mutate(prompt = data$prompt, iv_values=data$iv_values)
        } else {
          data <- sentiment_scores %>%
            dplyr::mutate(prompt = data$prompt)
        }
      } else {
        sentiment_scores <- data %>%
          sentimentr::get_sentences() %>%
          sentimentr::sentiment_by(by = c("row_num"), averaging_function=ave_func) %>%
          dplyr::rename(sentiment = ave_sentiment)
        if (!is.null(iv)) {
          data <- sentiment_scores %>%
            dplyr::mutate(iv_values = iv_vector)
        } else data <- sentiment_scores
      }
      
      # Make sure variable columns are of the correct data type.
      if (scoring_method != "by_row") data$prompt <- as.factor(data$prompt)
      if (!is.null(iv)) {
        if (iv_data_type == "factor") data$iv_values <- as.factor(data$iv_values)
        else data$iv_values <- as.numeric(data$iv_values)
      }
      
      # A function to obtain a set of colors based on the palette_colors option, of any
      # quantity.
      get_colors <- function(quantity) {
        colors_obj <- (quantity + 2) %>%
          colorRampPalette(RColorBrewer::brewer.pal(n=9, name=palette_colors))() %>%
          tail(-1) %>%
          head(-1)
        return(colors_obj)
      }
      
      # Get conditions for setting up the plot
      conditions <- private$.get_conditions()
      
      if (conditions$box_uncombined_iv_switched_facets) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "",
                                   y = sentiment,
                                   fill = iv_values,
                                   colour = iv_values)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::facet_wrap(~ prompt, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff"))
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_uncombined_iv_switched) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = prompt,
                                   y = sentiment,
                                   fill = iv_values,
                                   colour = iv_values)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::xlab("Survey Questions") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_uncombined_iv_facets) {
        
        pal <- get_colors(length(unique(data$prompt)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "", y = sentiment, fill = prompt, colour = prompt)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::facet_wrap(~ iv_values, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff"))
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_uncombined_iv) {
        
        pal <- get_colors(length(unique(data$prompt)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = iv_values,
                                   y = sentiment,
                                   fill = prompt,
                                   colour = prompt)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::xlab(iv) +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
      } else if (conditions$box_uncombined_switched_facets) {
        
        pal <- get_colors(1)
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "", y = sentiment, fill = "", colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::facet_wrap(~ prompt, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff")) +
          ggplot2::theme(legend.position = "none")
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_uncombined_switched) {
        
        pal <- get_colors(1)
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = prompt, y = sentiment, fill = "", colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::xlab("Survey Questions") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.position = "none")
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_uncombined) {
        
        pal <- get_colors(length(unique(data$prompt)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "", y = sentiment, fill = prompt, colour = prompt)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_iv_switched) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "",
                                   y = sentiment,
                                   fill = iv_values,
                                   colour = iv_values)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_iv_facets) {
        
        pal <- get_colors(1)
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "", y = sentiment, fill = "", colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::facet_wrap(~ iv_values, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff")) +
          ggplot2::theme(legend.position = "none")
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box_iv) {
        
        pal <- get_colors(1)
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = iv_values, y = sentiment, fill = "", colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::xlab(iv) +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.position = "none")
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$box) {
        
        pal <- get_colors(1)
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 25
        aesthetics <- ggplot2::aes(x = "", y = sentiment, fill = "", colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_boxplot(outlier.shape = if (add_graphics) NA else NULL) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::ylab("Sentiment Scores") +
          ggplot2::coord_flip() +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.position = "none")
        if(add_graphics) {
          plot <- plot +
            ggplot2::geom_point(alpha = 0.1,
                                position = ggplot2::position_jitterdodge(jitter.height = jitter_y))
        }
        
      } else if (conditions$density_uncombined_iv_switched_facets) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = iv_values,
                                                   colour = iv_values,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::facet_wrap(~ prompt, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff"))
        
      } else if (conditions$density_uncombined_iv_switched) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = prompt,
                                                   fill = iv_values,
                                                   colour = iv_values,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggplot2::ylab("Survey Questions") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        
      } else if (conditions$density_uncombined_iv_facets) {
        
        pal <- get_colors(length(unique(data$prompt)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = prompt,
                                                   colour = prompt,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::facet_wrap(~ iv_values, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff"))
        
      } else if (conditions$density_uncombined_iv) {
        
        pal <- get_colors(length(unique(data$prompt)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = iv_values,
                                                   fill = prompt,
                                                   colour = prompt,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggplot2::ylab(iv) +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        
      } else if (conditions$density_uncombined_switched_facets) {
        
        pal <- get_colors(1)
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = "",
                                                   colour = "",
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::facet_wrap(~ prompt, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff")) +
          ggplot2::theme(legend.position = "none")
        
      } else if (conditions$density_uncombined_switched) {
        
        pal <- get_colors(1)
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = prompt,
                                                   fill = "",
                                                   colour = "",
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggplot2::ylab("Survey Questions") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.position = "none")
        
      } else if (conditions$density_uncombined) {
        
        pal <- get_colors(length(unique(data$prompt)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = prompt,
                                                   colour = prompt,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        
      } else if (conditions$density_iv_switched) {
        
        pal <- get_colors(length(unique(data$iv_values)))
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = iv_values,
                                                   colour = iv_values,
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        
      } else if (conditions$density_iv_facets) {
        
        pal <- get_colors(1)
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = "",
                                                   colour = "",
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::facet_wrap(~ iv_values, ncol = 2) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff")) +
          ggplot2::theme(legend.position = "none")
        
      } else if (conditions$density_iv) {
        
        pal <- get_colors(1)
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = iv_values,
                                                   fill = "",
                                                   colour = "",
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggplot2::ylab(iv) +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.position = "none")
        
      } else if (conditions$density) {
        
        pal <- get_colors(1)
        plot <- ggplot2::ggplot(data, ggplot2::aes(x = sentiment,
                                                   y = "",
                                                   fill = "",
                                                   colour = "",
                                                   height = stat(density))) +
          ggridges::geom_density_ridges(stat = "density", alpha = 0.5) +
          ggplot2::scale_fill_manual(values = pal) +
          ggplot2::scale_colour_manual(values = colorspace::darken(pal,
                                                                   amount = 0.3,
                                                                   space = "combined")) +
          ggplot2::xlab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
          ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
          ggplot2::theme(legend.position = "none")
        
      } else if (conditions$scatterplot_uncombined_facets) {
        
        pal <- get_colors(length(unique(data$prompt)))
        jitter_x <- (max(data$iv_values) - min(data$iv_values)) / 60
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 60
        aesthetics <- ggplot2::aes(x = iv_values, y = sentiment, colour=prompt)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_point(position = ggplot2::position_jitter(width = jitter_x,
                                                                  height = jitter_y),
                              alpha = 0.8) +
          ggplot2::facet_wrap(~ prompt, ncol = 2) +
          ggplot2::scale_colour_manual(values = pal) +
          ggplot2::xlab(iv) +
          ggplot2::ylab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(strip.background = ggplot2::element_rect(fill="#ffffff")) +
          ggplot2::theme(legend.position = "none")
        if (add_graphics) plot <- plot + ggplot2::geom_smooth(method = "lm", se = FALSE)
        
      } else if (conditions$scatterplot_uncombined) {
        
        pal <- get_colors(length(unique(data$prompt)))
        jitter_x <- (max(data$iv_values) - min(data$iv_values)) / 60
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 60
        aesthetics <- ggplot2::aes(x = iv_values, y = sentiment, colour = prompt)
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_point(position = ggplot2::position_jitter(width = jitter_x,
                                                                  height = jitter_y),
                              alpha = 0.8) +
          ggplot2::scale_colour_manual(values = pal) +
          ggplot2::xlab(iv) +
          ggplot2::ylab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.title = ggplot2::element_blank())
        if (add_graphics) plot <- plot + ggplot2::geom_smooth(method = "lm", se = FALSE)
        
      } else if (conditions$scatterplot) {
        
        pal <- get_colors(1)
        jitter_x <- (max(data$iv_values) - min(data$iv_values)) / 60
        jitter_y <- (max(data$sentiment) - min(data$sentiment)) / 60
        aesthetics <- ggplot2::aes(x = iv_values, y = sentiment, colour = "")
        plot <- ggplot2::ggplot(data, aesthetics) +
          ggplot2::geom_point(position = ggplot2::position_jitter(width = jitter_x,
                                                                  height = jitter_y),
                              alpha = 0.8) +
          ggplot2::scale_colour_manual(values = pal) +
          ggplot2::xlab(iv) +
          ggplot2::ylab("Sentiment Scores") +
          ggpubr::theme_pubclean() +
          ggplot2::theme(legend.position = "none")
        if (add_graphics) plot <- plot + ggplot2::geom_smooth(method = "lm", se = FALSE)
        
      }
      
      # Finally, print the plot.
      print(plot)
      return(TRUE)
    }
  )
)
