# Not A Data Vis

This module provides functionality for categorical data visualization and text mining capabilities. It features diverging stacked bar charts which are useful for ordinal data visualization. Text mining capabilities include sentiment analysis, word cloud generation, and frequencies of emotional phrases classified under `anger`, `anticipation`, `disgust`, `fear`, `joy`, `sadness`, `surprise`, and/or `trust`.

The sentiment analysis is based on the `sentimentr` package in `R`, which hosts a lexicon-based sentiment detection algorithm based on the Syuzhet lexicon. On one hand, emotions are detected based on the NRC Emotion Lexicon. These lexicons are also the basis of word cloud generation.

## Installation

1. Download the .jmo file (click nadv_0.2.0.jmo, and hit the download button).
2. In Jamovi, click the Modules button on the top right.
3. Click on Manage Installed > Sideload.
4. Click the big upload button to browse files.
5. Select and open the .jmo file.

## Updating

1. In Jamovi, click the Modules button on the top right.
2. Click on Manage Installed > Installed and look for "nadv".
3. Click "Remove" and choose "OK".
4. Follow installation instructions above.

## Changelog

### Version 0.2.0

- Added new analyses: `Sentiment Analysis`, `Sentiment Terms`, and `Emotion Detection`.

### Version 0.1.4

- Corrected bar chart colors for the ordering changes implemented in the previous update.
- Corrected ordering of axis labels.

### Version 0.1.3

- Added image size customization options.
- Reversed ordering of response categories in bar charts (the topmost level of categorical variables is now the leftmost/lowermost bar).
- Fixed bug where including non-extreme unused levels shuffles the coloring of bars in a bar chart.

### Version 0.1.2

- Fixed bug where spaces in variable names cause errors.

### Version 0.1.1
- Fixed bug when selecting `Group by response variables` and adding a variable to `Split by`

### Version 0.1.0
- Official release