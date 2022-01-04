#### packages ####
packages.list <- list("tiff", "foreach", "doParallel")
sapply(packages.list, require, character.only = TRUE)
#### ####


intersection.save <- function(raw.path,
                              tiff.color1 = "Alexa 555 nonConfocal_fusion_1d - n000000.tif",
                              tiff.color2 = "Alexa 647 - nonConfocal_fusion_1d - n000000.tif",
                              treshold.set = 70,
                              methods = "zero",
                              output.filename) {
  
  # A function to take two images and create a third one, consisting of the intersection of the two former.
  # The intersection image has a brighter signal of two images if both of 
  # them has a signal exceeding a given threshold 
  
  # If you put treshold.set as a vector of multiple values, a stack will be created.
  
  writeTIFFDefault <- function(what, where){
    writeTIFF(what = what, 
              where =  where,
              bits.per.sample = 16,
              compression = "none")
  }
  well.folders <- list.dirs(raw.path, full.names = FALSE, recursive = FALSE)
  
  intersection.collapse <-
    function(image.matrix.1, image.matrix.2, 
             treshold.int){
      ifelse((image.matrix.1 >= (treshold.int/ 65535)) & 
               (image.matrix.2 >= (treshold.int/ 65535)),
             pmax(image.matrix.1, image.matrix.2),
             if(method == "zero"){
               0
             } else if(method == "pmin"){
               pmin(image.matrix.1, image.matrix.2)
             } 
      )
    }
  
  intersection.photos <- function(images.list,  
                                  method, treshold.int = 120){
    images.mean <- images.list[[1]]
    for(i in 1:length(images.list)){
      images.mean <- intersection.collapse(images.mean,images.list[[i]], treshold.int = treshold.int)
    }
    return(images.mean)
  }
  
  for(well.folder in well.folders){
    
    path.to.photos <- paste(raw.path, well.folder, sep = "")
    setwd(path.to.photos)
    
    images <- list()
    images[["555"]] <- readTIFF(source = 
                                  paste(path.to.photos, tiff.color1, sep = "/"))
    
    images[["647"]] <- readTIFF(source = 
                                  paste(path.to.photos, tiff.color2, sep = "/"))
    
    
    treshold.list <- list()
    for(method in methods){
      for(treshold in treshold.set){
        treshold.list[[as.character(treshold)]] <- intersection.photos(images.list = images,
                                                                       treshold.int = treshold,
                                                                       method = method)
      }
      
      filename <- paste(output.filename, ".tif", sep = '')
      
      path.output <- path.to.photos
      writeTIFFDefault(what = treshold.list,
                       where = paste(path.output, filename, sep="/"))
      
    }
  }
}
