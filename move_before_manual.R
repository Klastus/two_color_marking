#### packages ####

#### ####
move.photos <- function (from,
                         to,
                         what = c("Cells_confo0001.tif",
                                  "Sh_Nuclei_confo_filtered_dapi0001.tif")){
  
  # from - path to directory of wells, from which copy
  # to - path to directory of wells, to which copy
  
  all.wells <- list.dirs(path = from, full.names = FALSE, recursive = FALSE)
  for(well in all.wells){
    for(image in what){
      well.path.input <- paste(from, well, image, sep = "/")
      well.path.output <- paste(to, well, image, sep = "/")
      file.copy(from = well.path.input,
                to = well.path.output,
                overwrite = TRUE)
    }
  }
}