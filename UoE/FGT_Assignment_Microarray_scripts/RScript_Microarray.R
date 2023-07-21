setwd("~/FGT/week7")
dir()
untar("~/FGT/week7/GSE8969_RAW.tar")
#From FGT_T3_notes
library(affy)
adf<-read.AnnotatedDataFrame("samplen.txt",header=TRUE,row.names=1,as.is=TRUE)
samplen_file <- read.table("samplen.txt",header = TRUE,sep="")
CEL_files <- ReadAffy(filenames=pData(adf)$Filename,phenoData=adf)
#Histogram
png("CEL_files_histogram.png")
hist(CEL_files, type = "l", lwd = 1, main = "Histogram of AffyBatch data CEL_files")
dev.off()
#Boxplot of denormalized data
png("CEL_files_boxplot_denormalized.png")
#for vertical xlab names
par(las = 2)
boxplot(CEL_files,col=rep(c("red","green")),outline=TRUE,names=samplen_file$Name,xlab="Samples")
dev.off()
#Normalization
data_norm <- rma(CEL_files)
norm_values <- exprs(data_norm)
colnames(norm_values) <- samplen_file$Name
#Boxplot after normalization
png("CEL_files_boxplot_normalized.png")
#for vertical xlab names
par(las = 2)
boxplot(norm_values,col=rep(c("red","green")),outline=TRUE,names=colnames(norm_values),xlab="Samples")
dev.off()
#Quality control
png("MAplot.png")
mva.pairs(norm_values, labels = colnames(norm_values), digits = 2, line.col = 1, main = "MA plot", cex=1)
dev.off()
#Hierarchical clustering of normalized data
#Reference for usage of Spearman correlation: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5244536/ 
png("Hierarchical_clustering.png")
clust <- hclust(as.dist(1-cor(norm_values,method = "spearman")), method = "complete")
plot(clust, main = "Hierachical clustering of GSE8969 samples")
dev.off()
#PCA plot
#Reference: R documentation of scatterplot3d
library(scatterplot3d)
pca <- prcomp(t(norm_values), scale=T)
png("PCA plot.png")
#From FGT_T3_notes
scatter_pca<-scatterplot3d(pca$x[,1:3], pch=20, main = "PCA plot")
scatter_pca.coords <- scatter_pca$xyz.convert(pca$x[,1:6])
text(scatter_pca.coords$x, scatter_pca.coords$y, labels = colnames(norm_values),pos = 3,offset = 0.5)
dev.off()
#25/03/2022
#Getting expression values
exprs_data_norm <- exprs(data_norm)
exprs_data_norm10 <- 2^exprs_data_norm
#Getting sample names
mysamples <- sampleNames(data_norm)
mysamples
#Getting probe names 
probesets_8969 <- probeNames(CEL_files)
#Calculating the means for log FoldChange
KO_mean <- apply(exprs_data_norm10[,c("GSM227407.CEL.gz","GSM227408.CEL.gz","GSM227409.CEL.gz")],1,mean)
WT_mean <- apply(exprs_data_norm10[,c("GSM227410.CEL.gz","GSM227411.CEL.gz","GSM227412.CEL.gz")],1,mean)
#Calculation of fold changes comparing wildtype with knockout mice
WT_KO <- WT_mean/KO_mean
write.table(WT_KO, file="8969_group_means.txt", quote=F, sep = "\t", row.names = T, col.names = T)
#Changing the sample names to sensible ones
mysamples<-c("KO.1","KO.2","KO.3","WT.1","WT.2","WT.3")
mysamples
#Annotate results with matching gene names
library(mouse4302.db)
library(annotate)
ls("package:mouse4302.db")
Gene_ID <- featureNames(data_norm)
Gene_Symbol <- getSYMBOL(Gene_ID, "mouse4302.db")
Gene_Name <- as.character(lookUp(Gene_ID, "mouse4302.db", "GENENAME"))
gene_tmp <- data.frame(ID=Gene_ID, Symbol=Gene_Symbol, Gene_Name=Gene_Name, stringsAsFactors = F)
gene_tmp[gene_tmp=="NA"]
fData(data_norm) <- gene_tmp
#Constructing the design matrix
library(limma)
design <- model.matrix(~-1+factor(c(1,1,1,2,2,2)))
colnames(design) <- c("KO","WT")
design
contrastsmatrix <- makeContrasts(WT-KO,levels=design)
#Using limma
limma_fit <- lmFit(data_norm, design=design)
limma_fit2 <- contrasts.fit(limma_fit, contrastsmatrix)
limma_fit2 <- eBayes(limma_fit2)
topTable(limma_fit2,coef=1,adjust="fdr")
results <- topTable(limma_fit2,coef=1,adjust="fdr", number = nrow(data_norm))
results[results=="NA"] <- NA
results_without_NA <- na.omit(results)
write.table(results_without_NA,"results_1.txt")
write.csv(results_without_NA, "results_1.csv")
#Pair-wise comparisons
comp <- classifyTestsF(limma_fit2)
#26-03-2022
png("Venn_diagram.png")
vennDiagram(comp, names = "WT-KO", cex = 1,circle.col = "red")
dev.off()
#Load enrichment data
MMH <- readRDS("Mm.h.all.v7.1.entrez.rds")
#Use the mouse4302.db library
keytypes(mouse4302.db)
enrich_results <-  select(mouse4302.db, keys = rownames(data_norm), columns =
                            c("ENTREZID", "ENSEMBL","SYMBOL"), keytype="PROBEID")
idx <- match(rownames(data_norm), enrich_results$PROBEID)
idx
fData(data_norm) <- enrich_results[idx, ]
data_norm_no <-data_norm[is.na(fData(data_norm)$ENTREZID)==0,]
#Do the enrichment analysis using Romer - https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4402510/
Mmh.indices <- ids2indices(MMH,fData(data_norm_no)$ENTREZID)
enr <- romer(data_norm_no, index = Mmh.indices, design = design, contrast = contrastsmatrix, nrot = 1000, set.statistic = "mean")
head(enr,10)
write.table(enr,"enrichment.txt", quote=F, sep = "\t", row.names = T, col.names = T)
write.csv(enr, "enrichment.csv")
#27-0-2022
#Save .RData
save.image(file = "Pipeline.RData", safe = T)
#04-04-2022
write.csv(enrich_results, "symbols.csv")
