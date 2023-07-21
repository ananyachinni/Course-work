# FGT Assignment - Microarray Data Analysis

This sub-repository contains code for performing Microarray data analysis on a dataset.

## Description
### RScript_Microarray.R:
1. The TAR file of the GEO dataset was downloaded from the NCBI GEO database and was read using the _affy_ package.
2. Normalization of the data was done using the RMA algorithm and Boxplots, MA plots were drawn to check for outliers in the data.
3. Library _limma_ was used to create contrast and design matrices, eBayes fit for the data.
4. Libraries _mouse4302.db_ and _annotate_ were used to map the differentially expressed Affymetrix Probe IDs to their respective Gene Symbols.
5. The differentially expressed genes were subjected to functional annotation using romer (library _limma_).

### Volcano_plot_Shiny.R:
A Shiny application to display the Volcano plot for the differentially expressed genes was developed using libraries like _shiny, shinyjs, EnhancedVolcano_.
