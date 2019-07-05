#### packages ####
packages.list <- list("tiff", "foreach", "doParallel")
sapply(packages.list, require, character.only = TRUE)
#### ####
writeTIFFDefault <- function(what, where){
  writeTIFF(what = what, 
            where =  where,
            bits.per.sample = 16,
            compression = "none")
}

well.folders <- c("Well G09", "Well G10", "Well G11", "Well G12")
for(well.folder in well.folders){
  
path.to.photos <- paste("D:/Piotrek/scripts/two_color_marking/PT76/intact/", well.folder, "/", sep = "")
setwd(path.to.photos)

images <- list()
tiff.filename <- "Alexa 555 nonConfocal_fusion - n000000.tif"
images[["555"]] <- readTIFF(source = 
                              paste(path.to.photos, tiff.filename, sep = "/"))

tiff.filename <- "Alexa 647 - nonConfocal_fusion - n000000.tif"
images[["647"]] <- readTIFF(source = 
                              paste(path.to.photos, tiff.filename, sep = "/"))

simple.proj.fun <- function(
  images.list,
  collapsing,
  treshold.int = 120,
  method){
  images.mean <- images.list[[1]]
  if(collapsing=="intersection"){
    collapse.function <-
      function(image.matrix.1, image.matrix.2){
        ifelse((image.matrix.1 > (treshold.int/ 65535)) & 
                 (image.matrix.2 > (treshold.int/ 65535)),
               pmax(image.matrix.1, image.matrix.2),
               if(method == "zero"){
                 0
               } else if(method == "pmin"){
                 pmin(image.matrix.1, image.matrix.2)
               } 
        )
      }
    normalise.function =
      function(image.matrix){image.matrix}
  }
  for(i in 1:length(images.list)){
    images.mean <- collapse.function(images.mean,images.list[[i]])
  }
  images.mean <- normalise.function(images.mean)
  return(images.mean)
}

treshold.list <- list()
# treshold.set <- c(50, 70, 80, 100, 120, 150, 180, 200)
treshold.set <- 70


for(method in c("zero")){
for(treshold in treshold.set){
  treshold.list[[as.character(treshold)]] <- simple.proj.fun(images.list = images, 
                                                             collapsing = "intersection", 
                                                             treshold.int = treshold,
                                                             method = method)
}


filename <- paste("Min_proj_zero_70.tif", sep = '')

path.output <- path.to.photos
writeTIFFDefault(what = treshold.list,
                 where = paste(path.output, filename, sep="/"))

}
}

