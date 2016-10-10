
platform = "27"

# read metadata
files = read.table(paste0("met", platform, "k.file.tsv"), h=T, stringsAsFactors=F)

# check dup names
sum(duplicated(files$filename))

# transform metadata
files$in.file = paste0("./", platform, "k/", files$id, "/", files$filename)
files$out.file = paste0("./out", platform, "/", gsub("txt$", "gdc_hg38.txt", files$filename))
files$meta.file = paste0("hm", platform, ".manifest.hg38.gencode.v22.tsv")
files$log.file = paste0("log", platform, "/", files$filename, ".log")

cmd = with(files, paste("Rscript --vanilla met.liftover.R", in.file, out.file, meta.file, log.file))
write.table(cmd, paste0(platform, ".cmd"), col.names=F, row.names=F, quote=F)