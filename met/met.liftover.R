# met.liftover.R converts TCGA hg19 annotated methylation level 3 beta values to hg38  

# get arguments
args = commandArgs(trailingOnly = TRUE)
in.file = args[1]
out.file = args[2]
meta.file = args[3]
log.file = args[4]


library(data.table)
library(futile.logger)

# setup log file
flog.appender(appender.file(log.file))

# read TCGA methylation beta values in hg19 
beta19 = fread(in.file, skip=1, h=T, colClasses="character")
if(!("Composite Element REF" %in% names(beta19) & "Beta_value" %in% names(beta19))) {
	flog.error("Necessary columns do not exist in input %s", in.file)
}

# read hg38 annotation metadata
meta = fread(meta.file, colClasses="character")
setnames(meta, c("Chromosome", "Start", "End", "Composite_Element_REF", "Gene_Symbol", "Gene_Type", "Transcript_ID", "Position_to_TSS", "CGI_Coordinate", "Feature_Type"))

# match probeset 
m = match(beta19$"Composite Element REF", meta$Composite_Element_REF)
if(!setequal(m, 1:length(m))) {
	flog.warn("Probeset IDs do not match")
}
beta38 = cbind(beta19[, c("Composite Element REF", "Beta_value"), with=F], meta[m, -4, with=F])

# output
write.table(beta38, out.file, col.names=T, row.names=F, sep="\t", quote=F)