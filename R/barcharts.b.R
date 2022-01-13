barchartsClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "barchartsClass",
    inherit = barchartsBase,
    private = list(
        .run = function() {
            run_analysis <- TRUE
            vars <- self$options$vars
            if(is.null(vars)) {
                run_analysis <- FALSE
            }
            if(run_analysis) {
                data <- self$data
                groupvar <- self$options$group
                order <- c()
                for(var in vars) {
                    order <- order %>% union(levels(data[[var]]))
                }
                if(is.null(groupvar)) {
                    data <- data %>% 
                        gather(key='item', value='response', na.rm=TRUE)
                    data <- data %>%
                        group_by(item, response) %>%
                        summarise(count=n())
                    colnames(data) <- c('item', 'response', 'freq')
                }
                else {
                    names(data)[names(data) == groupvar] <- 'gvariable'
                    data <- data %>% 
                        filter(!is.na(gvariable)) %>%
                        gather(key='item', value='response', 
                               -gvariable, na.rm=TRUE)
                    data <- data %>%
                        group_by(gvariable, item, 
                                 response) %>%
                        summarise(count=n())
                    colnames(data) <- c('group', 'item', 'response', 'freq')
                }
                image <- self$results$barchart
                image$setState(list(data=data, order=order))
                size <- private$.plotSize(data)
                image$setSize(size$width, size$height)
            }
            else {
                self$results$text$setVisible(TRUE)
                text_string <- "Thank you for installing Not A Data Vis!</br>
                </br>This module attempts to provide various controls for
                generating clean bar charts. Feel free to drag and drop some
                raw categorical variables into the listboxes, and play around
                with the UI 'til you get what you need.</br></br>"
                self$results$text$setContent(text_string)
            }
        },
        .plotSize = function(data) {
            imgsizemode <- self$options$imgsizemode
            if(imgsizemode == 'customsize') {
                imgwidth <- self$options$imgwidth
                imgheight <- self$options$imgheight
                return(list(width=imgwidth, height=imgheight))
            }
            type <- self$options$type
            groupvar <- self$options$group
            format <- self$options$format
            flip_axes <- self$options$flip_axes
            barSize <- 25
            nGroups <- 1
            legendSize <- 25 + 25 * ceiling(length(unique(data$response)) / 5)
            stripSize <- 0
            axisSize <- 25
            labelSize <- 25
            if(!is.null(groupvar)) {
                stripSize <- 25
                nGroups <- length(unique(data$group))
            }
            nItems <- length(unique(data$item))
            if(format == 'long') {
                dummyvar <- nGroups
                nGroups <- nItems
                nItems <- dummyvar
                stripSize <- 25
            }
            if(type == 'grouped') {
                nBars <- 1
                for(var in unique(data$item)) {
                    if(!is.null(groupvar)) {
                        for(g in unique(data$group)) {
                            sub <- subset(data, group == g && item == var)
                            nBars <- max(nBars, 
                                         length(unique(sub$response)))
                        }
                    }
                    else {
                        sub <- subset(data, item == var)
                        nBars <- max(nBars, length(unique(sub$response)))
                    }
                }
                imageWidth <- ifelse(flip_axes, 
                                     550, max(550, barSize * nBars * nItems +
                                                  axisSize + labelSize))
                imageHeight <- legendSize + axisSize + labelSize +
                    ifelse(flip_axes, barSize * nBars * nItems + stripSize, 
                           300) * 
                    ceiling(nGroups / 2)
                if(nGroups > 1) {
                    imageHeight <- imageHeight * 0.75
                }
                imageHeight <- max(imageHeight, 300)
            }
            else{
                barSize <- 35
                imageWidth <- ifelse(flip_axes,
                                     550, max(barSize * nItems +
                                                  axisSize + labelSize, 550))
                imageHeight <- legendSize + axisSize + labelSize +
                    ifelse(flip_axes, barSize * nItems + stripSize, 300) *
                    ceiling(nGroups / 2)
            }
            return(list(width=imageWidth, height=imageHeight))
        },
        .plot = function(image, ...) {
            create_plot <- TRUE
            if(is.null(self$options$vars)) {
                create_plot <- FALSE
                FALSE
            }
            if(create_plot) {
                data <- image$state$data
                order <- image$state$order
                data$response <- factor(data$response, levels=rev(order))
                format <- self$options$format
                groupvar <- self$options$group
                vars <- self$options$vars
                type <- self$options$type
                display <- self$options$display
                percent <- self$options$percent
                flip_axes <- self$options$flip_axes
                sort <- self$options$sort
                palette <- self$options$palcolor
                items_title <- self$options$items_title
                items_name <- self$options$items_name
                freq_title <- self$options$freq_title
                showlegend <- self$options$showlegend
                stripColor <- "#eeeeee"
                if(flip_axes) {
                    stripColor <- "#ffffff"
                }
                pal = colorRampPalette(brewer.pal(n=5, 
                                                 name=palette))(length(order))
                if(is.null(groupvar)) {
                    data <- data %>% mutate(dummyvar='')
                }
                if(percent) {
                    if(!is.null(groupvar)) {
                        data <- data %>% group_by(group, item)
                    }
                    else {
                        data <- data %>% group_by(item)
                    }
                    data <- data %>%
                        mutate(group_sum=sum(freq)) %>%
                        ungroup()
                }
                if(type == 'grouped') {
                    data$response <- factor(data$response, levels=order)
                    if(percent) {
                        data <- data %>% mutate(freq = freq/group_sum)
                    }
                    if(format == 'wide') {
                        plot <- ggplot(data, aes(x=item, y=freq,
                                                 label=if(percent) 
                                    label_percent(accuracy=1L)(round(freq,2)) 
                                                 else freq,
                                                 fill=response)) +
                            geom_bar(stat='identity', 
                                     position=position_dodge2(width=0.8, 
                                                            preserve='single'),
                                     width=1) +
                            xlab(items_name) +
                            ylab('Frequency')
                        if(!is.null(groupvar)) {
                            plot <- plot +
                                facet_wrap(~ group, ncol=2)
                        }
                    }
                    else {
                        plot <- ggplot(data, aes(x=if(!is.null(groupvar)) group 
                                                 else dummyvar, y=freq,
                                                 label=if(percent) 
                                    label_percent(accuracy=1L)(round(freq,2)) 
                                                 else freq, 
                                                 fill=response)) +
                            geom_bar(stat='identity', 
                                     position=position_dodge2(0.8,
                                                            preserve='single'),
                                     width=1) +
                            facet_wrap(~ item, ncol=2) +
                            xlab(ifelse(!is.null(groupvar), groupvar, 
                                        'Responses')) +
                            ylab('Frequency')
                    }
                    if(display) {
                        plot <- plot +
                            geom_text(position=position_dodge2(1, 
                                                            preserve='single'),
                                      aes(y=freq + max(freq) * 0.05))
                    }
                    if(percent) {
                        plot <- plot +
                            scale_y_continuous(labels=scales::percent)
                    }
                }
                else if(type == 'stacked') {
                    if(format == 'wide'){
                        plot <- ggplot(data, aes(x=item, y=if(percent) 
                            freq/group_sum else freq, fill=response)) +
                            xlab(items_name) +
                            ylab('Frequency')
                        if(!is.null(groupvar)) {
                            plot <- plot +
                                facet_wrap(~ group, ncol=2)
                        }
                    }
                    else {
                        plot <- ggplot(data, aes(x=if(!is.null(groupvar)) group 
                                                 else dummyvar, y=if(percent) 
                                                     freq/group_sum else freq,
                                                 fill=response)) +
                            facet_wrap(~ item, ncol=2) +
                            xlab(ifelse(!is.null(groupvar), groupvar, 
                                        'Responses')) +
                            ylab('Frequency')
                    }
                    plot <- plot + geom_bar(stat='identity',
                                            position=if(percent) 'fill' 
                                            else 'stack',
                                            width=0.8)
                    if(display) {
                        plot <- plot + 
                            geom_text(aes(label=if(percent) 
                            label_percent(accuracy=1L)(round(freq/group_sum,2)) 
                                else freq), position=position_stack(vjust=.5))
                    }
                    if(percent) {
                        plot <- plot +
                            scale_y_continuous(labels=scales::percent)
                    }
                }
                else if(type == 'diverging') {
                    cats <- levels(data$response)
                    midlevel <- ceiling(length(cats) / 2)
                    midrating <- if(length(cats) %% 2) cats[midlevel] else 
                        "sup DAC person, this code is a disaster holy shit"
                    if(percent) {
                        data <- data %>% mutate(freq = freq/group_sum)
                    }
                    if(format == 'wide') {
                        if(sort) {
                            data <- data %>% group_by(item) %>%
                                mutate(pos=sum(
                                    ifelse(response == midrating, 0.5 * freq,
                                           ifelse(response %in% 
                                                      head(cats, midlevel),
                                                  freq, 0)))) %>% ungroup()
                            data$item <- reorder(data$item, data$pos)
                        }
                        if(!is.null(groupvar)) {
                            data <- data %>% group_by(group, item)
                        }
                        else {
                            data <- data %>% group_by(item)
                        }
                        data <- data %>% arrange(desc(match(response, cats)), 
                                                 .by_group=TRUE)
                        plot <- ggplot(data, aes(x=item, y=freq)) +
                            xlab(items_name) +
                            ylab('Frequency')
                        if(!is.null(groupvar)) {
                            plot <- plot +
                                facet_wrap(~ group, ncol=2)
                        }
                    }
                    else {
                        if(sort && !is.null(groupvar)) {
                            data <- data %>% group_by(group) %>%
                                mutate(pos=sum(
                                    ifelse(response == midrating, 0.5 * freq,
                                           ifelse(response %in% 
                                                      head(cats, midlevel),
                                                  freq, 0)))) %>% ungroup()
                            data$group <- reorder(data$group, data$pos)
                        }
                        if(!is.null(groupvar)) {
                            data <- data %>% group_by(group, item)
                        }
                        else {
                            data <- data %>% group_by(item)
                        }
                        data <- data %>% arrange(desc(match(response, cats)), 
                                                 .by_group=TRUE)
                        plot <- ggplot(data, aes(x=if(!is.null(groupvar)) group
                                                 else dummyvar)) +
                            facet_wrap(~ item, ncol=2) +
                            xlab(ifelse(!is.null(groupvar), groupvar, 
                                        'Responses')) +
                            ylab('Frequency')
                    }
                    hsub <- subset(data, response %in% head(cats, midlevel))
                    tsub <- subset(data, response %in% tail(cats, midlevel))
                    plot <- plot +
                        geom_bar(data=hsub,
                                 mapping=aes(y=ifelse(response == midrating, 
                                                      .5 * freq, freq),
                                             fill=response),
                                 position='stack', stat='identity',
                                 width=0.8) +
                        geom_bar(data=tsub,
                                 mapping=aes(y=-ifelse(response == midrating,
                                                       .5 * freq, freq),
                                             fill=response),
                                 position=position_stack(reverse=TRUE),
                                 stat='identity',
                                 width=0.8) +
                        scale_x_discrete(limits=levels(data$item))
                    if(percent) {
                        plot <- plot + 
                            scale_y_continuous(labels=scales::percent)
                    }
                    if(display) {
                        data <- data %>%
                            mutate(labelpos=sum(-ifelse(response == midrating,
                                                        .5 * freq, 
                                                        ifelse(response %in% 
                                                                   tail(cats, 
                                                                    midlevel),
                                                               freq, 0))) +
                                       cumsum(freq) - .5 * freq) %>% ungroup()
                        plot <- plot +
                            geom_text(mapping=aes(label=if(percent) 
                                label_percent(accuracy=1L)(round(freq,2)) else 
                                    freq,
                                y=data$labelpos))
                    }
                }
                if(flip_axes) {
                    plot <- plot + coord_flip()
                }
                if(type != 'diverging' || !sort) {
                    if(format == 'long' && !is.null(groupvar)) {
                        plot <- plot +
                            scale_x_discrete(
                                limits=if(flip_axes) rev(levels(data$group))
                                else levels(data$group))
                    }
                    if(format == 'wide') {
                        plot <- plot +
                            scale_x_discrete(limits=if(flip_axes) rev(vars)
                                             else vars)
                    }
                }
                dummyframe <- data.frame(response=order, colors=pal)
                if(type == 'diverging') {
                    nresponse = 0
                    for(it in unique(data$item)) {
                        isub <- subset(data, item == it)
                        nresponse <- max(nresponse, 
                                         length(unique(isub$response)))
                    }
                    if(nresponse > 3) {
                        dummyframe <- dummyframe[order(dummyframe$response),]
                    }
                    else {
                        dummyframe <- dummyframe[nrow(dummyframe):1,]
                    }
                }
                subframe <- subset(dummyframe,
                                   response %in% unique(data$response))
                final_colors <- if(type != 'stacked') subframe$colors else
                    rev(subframe$colors)
                plot <- plot + scale_fill_manual(values=final_colors)
                plot <- plot + theme_pubclean() +
                    theme(legend.title=element_blank()) +
                    theme(strip.background=element_rect(fill=stripColor))
                if(!items_title) {
                    if(flip_axes) {
                        plot <- plot + theme(axis.title.y=element_blank())
                    }
                    else {
                        plot <- plot + theme(axis.title.x=element_blank())
                    }
                }
                if(!freq_title) {
                    if(flip_axes) {
                        plot <- plot + theme(axis.title.x=element_blank())
                    }
                    else {
                        plot <- plot + theme(axis.title.y=element_blank())
                    }
                }
                if(!showlegend) {
                    plot <- plot + theme(legend.position='none')
                }
                print(plot)
                TRUE
            }
        }
    )
)