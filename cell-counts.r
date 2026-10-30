## ----globals -------------------------------------------------------------
packages <- c("meffil", "eval.save") 
lapply(packages, require, character.only=T)

dir <- paths

if(!dir.exists(dir$cache)) dir.create(dir$cache)
eval.save.dir(dir$cache)

options(mc.cores=16)
packageVersion("meffil")

## ----idats -------------------------------------------------------------
dir$idats <- file.path(dir$data, "protect/combined-raw")

## ----files -------------------------------------------------------------
file <- list()
file$cellcount <- file.path(dir$release, "cellcounts", "blood-gse35069-complete.csv")

# Recursively make directories for a vector of filepaths and 
# return logic of success
make_dirs <- function(paths) {
  sapply(paths, function(p) {
    if (!dir.exists(p)) dir.create(p, recursive = TRUE)
    dir.exists(p)
  })
}

make_dirs(paths = 
			c(dir$release, 
			dirname(unlist(file))))

## ----parameters -------------------------------------------------------------
param <- list()
param$verbose <- TRUE  
param$qc <- meffil.qc.parameters()

run <- list()
run$qc <- TRUE

## ----samplesheet -------------------------------------------------------------
samplesheet <- meffil.create.samplesheet(dir$idats, recursive=TRUE)

## ----qc -------------------------------------------------------------
meffil.list.featuresets()

eval.save({
	qc.objects <- meffil.qc(samplesheet,  
					cell.type.reference = "blood gse35069 complete", 
					verbose = param$verbose,
					detection.threshold = 0.01)	## default but specifying for clarity
}, "qc.objects", redo=run$qc)
qc.objects <- eval.ret("qc.objects")

counts <- t(meffil.cell.count.estimates(qc.objects))
data.table::fwrite(counts, file = file$cellcount)


