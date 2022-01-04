#### Create a stack from marked nuclei and both CellTrace images ####
library(foreach)
library(doParallel)

outlines.to.stack <- function(exp.input, 
                            exp.output = exp.input, 
                            dyes, 
                            contrast.max, 
                            cores=10,
                            path.to.fiji = "D:/Piotrek/programs/Fiji.app"){
  
  push.dir <- function(folder.name){
    if(!dir.exists(folder.name)){
      dir.create(folder.name, recursive = TRUE)
    }
  }
  
  dye.string <- paste(dyes, collapse = ',')
  max.string <- paste(contrast.max, collapse = ',')
  command.base <- "ImageJ-win64.exe --console --headless -macro nuclei_to_stack_.ijm"
  # command.base <- "ImageJ-win64.exe --console -macro nuclei_to_stack_.ijm"
  # command.base <- "ImageJ-win64.exe -macro color_merge_.ijm"
  
  well.list <- list.dirs(exp.input, full.names = FALSE, recursive = FALSE)
  
  setwd(path.to.fiji)
  num.Cores <- cores
  registerDoParallel(num.Cores)
  foreach(well = well.list) %dopar% {
    input <- paste(exp.input, well, "/", sep = '')
    output <- paste(exp.output, well, "/",  sep = '')
    push.dir(output)
    command <- paste(command.base, ' "', input, ";", output, ";", 
                     dye.string, ";", max.string, ";", sep = '')
    system(command)
  }
  stopImplicitCluster()
  
}





