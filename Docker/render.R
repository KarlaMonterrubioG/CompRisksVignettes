rmds <- list.files("Source", pattern = "*.Rmd")
# Could use foreach to process in parallel. Introduces additional dependency.
for (rmd in rmds) {
  rmarkdown::render(paste0("Source/", rmd),
                    output_format = "html_document",
                    output_dir = "docs")
}
