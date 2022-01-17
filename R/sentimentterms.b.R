sentimenttermsClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
  "sentimenttermsClass",
  inherit = sentimenttermsBase,
  private = list(
    .run = function() {
      
      # Collect all relevant input data and controls
      data <- self$data
      sentiment_data <- self$options$sentiment_data
      split_var <- self$options$split_var
      switch <- self$options$switch
      combine_wordclouds <- self$options$combine_wordclouds
      analysis_mode <- self$options$analysis_mode
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
      
      # Assign image sizes of the word clouds based on user input.
      if (custom_img_size) {
        img_width <- custom_width
        img_height <- custom_height
      } else {
        img_width <- 550
        img_height <- 550
      }
      
      # Begin assigning data to the individual word clouds.
      images <- self$results$plots
      images$setVisible(TRUE)
      
      if ((!switch && is.null(split_var)) || combine_wordclouds) {
        
        if (analysis_mode == "comparison") plot_name <- "Most Unevenly Distributed Words"
        else plot_name <- "Most Frequent Words"
        images$addItem(key = plot_name)
        image <- images$get(key = plot_name)
        image$setSize(img_width, img_height)
        image$setState(data)
        
      } else if (!switch && !is.null(split_var)) {
        
        for (level in unique(data$split_var)) {
          images$addItem(key = as.character(level))
          image <- images$get(key = as.character(level))
          image$setSize(img_width, img_height)
          sub_data <- data %>%
            subset(split_var == level)
          image$setState(sub_data)
        }
        
      } else {
        
        for (level in unique(data$prompt)) {
          images$addItem(key = as.character(level))
          image <- images$get(key = as.character(level))
          image$setSize(img_width, img_height)
          sub_data <- data %>%
            subset(prompt == level)
          image$setState(sub_data)
        }
        
      }
      
    },
    .plot = function(image, ...) {
      
      # Collect data specific to this word cloud. If null, it means that the analysis threw an error.
      data <- image$state
      if (is.null(data)) return(FALSE)
      
      # Collect all relevant control inputs.
      sentiment_data <- self$options$sentiment_data
      split_var <- self$options$split_var
      sentiment_type <- self$options$sentiment_type
      analysis_mode <- self$options$analysis_mode
      switch <- self$options$switch
      font_family <- self$options$font_family
      font_face <- self$options$font_face
      palette_colors <- self$options$palette_colors
      scale_percentage <- self$options$scale_percentage
      max_words <- self$options$max_words
      drop <- self$options$drop
      
      # If the user wants to modify the lexicon, do this.
      if (grepl("[A-Za-z]", drop)) {
        words_vect <- unlist(strsplit(gsub(" ", "", tolower(drop)), ","))
        sentiment_lex <- lexicon::hash_sentiment_jockers_rinker %>%
          sentimentr::update_key(drop = words_vect)
        emotion_lex <- lexicon::hash_nrc_emotions[!(lexicon::hash_nrc_emotions$token %in% words_vect), ] %>%
          data.table::setkey(token)
      } else {
        sentiment_lex <- lexicon::hash_sentiment_jockers_rinker
        emotion_lex <- lexicon::hash_nrc_emotions
      }
      
      # Function for extracting a table of word frequencies
      word_frequencies <- function(char_vector) {
        if (sentiment_type %in% c("all", "positive", "negative")) {
          dataset <- char_vector %>%
            sentimentr::get_sentences() %>%
            sentimentr::extract_sentiment_terms(polarity_dt = sentiment_lex)
        } else {
          dataset <- char_vector %>%
            sentimentr::get_sentences() %>%
            sentimentr::extract_emotion_terms(emotion_dt = emotion_lex)
        }
        
        dataset <- attributes(dataset)$counts
        
        if (sentiment_type == "all") {
          dataset <- dataset %>%
            subset(polarity != 0)
        } else if (sentiment_type == "positive") {
          dataset <- dataset %>%
            subset(polarity > 0)
        } else if (sentiment_type == "negative") {
          dataset <- dataset %>%
            subset(polarity < 0)
        } else {
          dataset <- dataset %>%
            subset(emotion_type == sentiment_type)
        }
        
        return(dataset)
        
      }
      
      font_style <- switch(font_face,
                           normal = 1,
                           bold = 2,
                           italics = 3,
                           bold_italics = 4)
      
      color_pal <- RColorBrewer::brewer.pal(n=9, name=palette_colors) %>%
        colorspace::darken(amount = 0.5, space = "combined")
      
      if (analysis_mode == "aggregate") {
        
        # In this case, we can go straight to plotting the wordcloud.
        data <- word_frequencies(data$response)
        wordcloud::wordcloud(words = data$words,
                             freq = data$n,
                             max.words = max_words,
                             scale = c(scale_percentage * 4 / 100,
                                       scale_percentage * 0.5 / 100),
                             random.order = FALSE,
                             colors = color_pal,
                             min.freq = 1,
                             family = font_family,
                             font = font_style)
        
      } else {
        
        # In this case, we'll be comparing within individual word clouds. The grouping variable is
        # indicated by split_vect. What we need to do is convert data into a frequency matrix where
        # rows are represented by words while columns represent the levels of the grouping
        # variable.
        
        # Here, we'll split the "data" dataset into smaller datasets corresponding to the individual
        # values of the grouping variable. Then we'll transform them into their corresponding
        # word frequency tables.
        data_frames <- list()
        column_names <- c()
        split_vect <- if (switch) "split_var" else "prompt"
        for (level in unique(data[[split_vect]])) {
          sub_data <- data %>%
            subset(get(split_vect) == level)
          sub_data <- word_frequencies(sub_data$response)[ , c("words", "n")]
          names(sub_data)[names(sub_data) == "n"] <- as.character(level)
          column_names <- c(column_names, as.character(level))
          data_frames <- c(data_frames, list(sub_data))
        }
        
        # All of these datasets have a common "words" column, but their word count columns are named
        # after their respective grouping variable levels. This makes it convenient to use the
        # merge() function to obtain the frequency matrix we're after. We'll use a recursive
        # function to do this.
        tabulate <- function(data_frame_list) {
          if (length(data_frame_list) == 1) return(data_frame_list[1])
          return(merge(data_frame_list[1], tabulate(data_frame_list[-1]), all = TRUE))
        }
        freq_table <- tabulate(data_frames)
        
        # Our frequency table looks very close to what we're after, but there may be missing values
        # in cells that are supposed to be 0. This is because a certain grouping variable level
        # may correspond to data that doesn't include the word on the row of that cell.
        freq_table[is.na(freq_table)] <- 0
        
        # Finally, we can convert this table into a matrix.
        freq_matrix <- as.matrix(freq_table[ , -which(names(freq_table) == "words")])
        rownames(freq_matrix) <- freq_table[ , which(names(freq_table) == "words")]
        colnames(freq_matrix) <- column_names
        
        # We can now proceed to plotting.
        if (analysis_mode == "commonalities") {
          wordcloud::commonality.cloud(term.matrix = freq_matrix,
                                       max.words = max_words,
                                       scale = c(scale_percentage * 4 / 100,
                                                 scale_percentage * 0.5 / 100),
                                       random.order = FALSE,
                                       colors = color_pal,
                                       family = font_family,
                                       font = font_style)
        } else {
          group_colors <- colorRampPalette(color_pal)(length(column_names))
          wordcloud::comparison.cloud(term.matrix = freq_matrix,
                                      max.words = max_words,
                                      scale = c(scale_percentage * 4 / 100,
                                                scale_percentage * 0.5 / 100),
                                      random.order = FALSE,
                                      min.freq = 1,
                                      colors = group_colors,
                                      match.colors = TRUE,
                                      title.size = 1,
                                      family = font_family,
                                      font = font_style)
        }
      }
      
      return(TRUE)
      
    }
  )
)
