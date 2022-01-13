piechartsClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "piechartsClass",
    inherit = piechartsBase,
    private = list(
        .run = function() {
            run_analysis <- TRUE
            vars <- self$options$vars
            groupvar <- self$options$group
            if(is.null(vars)) {
                run_analysis <- FALSE
            }
            if(run_analysis) {
                data <- self$data
                plots <- self$results$piecharts
                for(var in vars) {
                    plots$addItem(key=var)
                    image <- plots$get(key=var)
                    size <- private$.plotSize(var)
                    image$setSize(size$width, size$height)
                    image$setState(list(data=data, var=var))
                }
            }
            else {
                self$results$text$setVisible(TRUE)
                text_string <- "Thank you for installing Not A Data Vis!</br>
                </br>This module attempts to provide various controls for
                generating clean pie charts. Feel free to drag and drop some
                raw categorical variables into the listboxes, and play around
                with the UI 'til you get what you need.</br></br>"
                self$results$text$setContent(text_string)
            }
        },
        .plotSize = function(var) {
            imageWidth <- 550
            groupvar <- self$options$group
            legendSize <- 25
            titleSize <- 0
            stripSize <- 0
            nGroups <- 1
            if(!is.null(groupvar)) {
                nGroups <- length(unique(self$data[[groupvar]]))
                stripSize <- 25
            }
            if(self$options$showlegend) {
                legendSize <- 50
            }
            if(self$options$showtitle) {
                titleSize <- 25
            }
            imageHeight <- max(legendSize + titleSize +
                ceiling(nGroups / 2) * (225 + stripSize), 550)
            return(list(width=imageWidth, height=imageHeight))
        },
        .plot = function(image, ...) {
            create_plot <- TRUE
            vars <- self$options$vars
            if(is.null(vars)) {
                create_plot <- FALSE
                FALSE
            }
            if(create_plot) {
                data <- image$state$data
                var <- image$state$var
                groupvar <- self$options$group
                showtitle <- self$options$showtitle
                showlabels <- self$options$showlabels
                labeltype <- self$options$labeltype
                invertcolors <- self$options$invertcolors
                showlegend <- self$options$showlegend
                palcolor <- self$options$palcolor
                names(data)[names(data) == var] <- 'variable'
                names(data)[names(data) == groupvar] <- 'gvariable'
                data <- data %>% filter(!is.na(variable))
                if(!is.null(groupvar)) {
                    data <- data %>%
                        filter(!is.na(gvariable)) %>%
                        group_by(gvariable, 
                                 variable) %>%
                        summarise(freq=n()) %>%
                        mutate(perc=freq / sum(freq)) %>% ungroup()
                    colnames(data) <- c('group', 'response', 'freq', 'perc')
                }
                else {
                    data <- data %>%
                        group_by(variable) %>%
                        summarise(freq=n()) %>% 
                        mutate(perc=freq / sum(freq)) %>% ungroup()
                    colnames(data) <- c('response', 'freq', 'perc')
                }
                plot <- ggplot(data, aes(x='', y=perc, fill=response)) +
                    geom_bar(position='stack', stat='identity', width=1) +
                    coord_polar('y', start=0)
                if(showlabels) {
                    if(!is.null(groupvar)) {
                        data <- data %>% group_by(group)
                    }
                    data <- data %>% arrange(desc(response)) %>%
                        mutate(ypos=cumsum(perc)-.5*perc) %>% ungroup()
                    plot <- plot +
                        geom_text(data, mapping=aes(y=ypos, 
                        label=if(labeltype == 'percentage')
                            label_percent(accuracy=1L)(round(perc, 2))
                            else freq), color=if(invertcolors) 'white'
                            else 'black')
                }
                pal = colorRampPalette(brewer.pal(n=5, 
                        name=palcolor))(length(unique(data[['response']])))
                plot <- plot +
                    theme_pubclean() +
                    theme(axis.text=element_blank()) +
                    theme(axis.title.x=element_blank()) +
                    theme(axis.title.y=element_blank()) +
                    theme(legend.title=element_blank()) +
                    theme(strip.background=element_rect(fill="#ffffff")) +
                    scale_fill_manual(values=pal)
                if(showtitle) {
                    plot <- plot +
                        labs(title=var)
                }
                if(!is.null(groupvar)) {
                    plot <- plot + facet_wrap(~ group, ncol=2)
                }
                print(plot)
                TRUE
            }
        }
    )
)
