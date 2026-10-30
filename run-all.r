args <- commandArgs(trailingOnly=TRUE)

config.name <- "default"
if (length(args) > 0)
    config.name <- args[1]

paths <- config::get(config=config.name)
print(paths)

paths$data <- file.path(paths$project, "data")
paths$output <- file.path(paths$project, "results")
paths$cache <- file.path(paths$project, "results", "analysis-cache")
paths$release <- file.path(paths$output, "releases", format(Sys.Date(), "2026-10-30"))

print(paths)

# make the cell counts
source("cell-counts.r", echo=T, max.deparse.length = 500)
