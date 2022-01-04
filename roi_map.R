#### Create a mop of all ROIs of manually marked nuclei ####
library(foreach)
library(doParallel)

map.roi.loci <- function(exp.input, 
                            exp.output = exp.input,
                    base.image = "DAPI Confocal", 
                            cores=10,
                    path.to.fiji = "D:/Piotrek/programs/Fiji.app"){
  
  push.dir <- function(folder.name){
    if(!dir.exists(folder.name)){
      dir.create(folder.name, recursive = TRUE)
    }
  }
  
  # command.base <- "ImageJ-win64.exe --console --headless -macro loci_roimap_.ijm"
  command.base <- "ImageJ-win64.exe --console -macro loci_roimap_.ijm"
  
  well.list <- list.dirs(exp.input, full.names = FALSE, recursive = FALSE)
  
  setwd(path.to.fiji)
  # num.Cores <- cores
  # registerDoParallel(num.Cores)
  foreach(well = well.list) %do% {
    input <- paste(exp.input, well, "/", sep = '')
    output <- paste(exp.output, well, "/",  sep = '')
    push.dir(output)
    command <- paste(command.base, ' "', input, ";", output, ";", 
                     base.image, ";", sep = '')
    system(command)
  }
  # stopImplicitCluster()
  
}

map.roi <- function(exp.input, 
                    exp.output = exp.input, 
                    cores=10,
                    path.to.fiji = "D:/Piotrek/programs/Fiji.app"){
  
  push.dir <- function(folder.name){
    if(!dir.exists(folder.name)){
      dir.create(folder.name, recursive = TRUE)
    }
  }
  
  # command.base <- "ImageJ-win64.exe --console --headless -macro loci_roimap_.ijm"
  command.base <- "ImageJ-win64.exe --console -macro manual_roimap_.ijm"

  
  well.list <- list.dirs(exp.input, full.names = FALSE, recursive = FALSE)
  
  setwd(path.to.fiji)
  # num.Cores <- cores
  # registerDoParallel(num.Cores)
  foreach(well = well.list) %do% {
    input <- paste(exp.input, well, "/", sep = '')
    output <- paste(exp.output, well, "/",  sep = '')
    push.dir(output)
    command <- paste(command.base, ' "', input, ";", output, ";", sep = '')
    system(command)
  }
  # stopImplicitCluster()
  
}





