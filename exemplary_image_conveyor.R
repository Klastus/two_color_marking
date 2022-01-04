#### load functions needed in an image analysis process ####
#### The process has a form of a conveyor (one after the other) ####

# Used only on Windows!

# Prerequisites:
# - A folder with microscopic images. This was tested for images from Pathway 
# microscope, but should work for any tiff images, probably after some adjustment
# - Fiji installed with imagej macros copied into the "Fiji.app/macros" folder:
# crop_stack_.ijm
# loci_roimap_.ijm
# manual_roimap_.ijm
# nuclei_to_stack_.ijm
# Those scripts will be uploaded to my github
# - black.tiff image copied somewhere. Personally, I kept it in the Fiji. directory
# - some lines for StartupMacros.fiji.ijm are helpful for 
# manual marking, but not necessary

#  Load functions. The scripts below will be uploaded to my github
# if an error occurs with any package, install it manually:
# install.packages("package_name")
source("D:/Piotrek/scripts/two_color_marking/R/intersection_projection.R")
source("D:/Piotrek/scripts/two_color_marking/R/move_before_manual.R")
source("D:/Piotrek/scripts/two_color_marking/R/outlines_to_stack.R")
source("D:/Piotrek/scripts/two_color_marking/R/roi_map.R")

### Stage I: create intersection projection ####
path.to.raw <- "D:/Piotrek/images/Adithya/example_syncytia_processed/2022-01-04/"
intersection.save(raw.path = path.to.raw,
                  output.filename = "zero_intersection",
                  treshold.set = 50,
                  tiff.color1 = "Alexa 555 Confocal fusion - n000000.tif",
                  tiff.color2 = "Alexa 647 - Confocal fusion - n000000.tif")

# if a threshold.set is a vector, a stack of images will be created. 
# It's useful for testing the threshold:

# path.to.raw <- "D:/Piotrek/Experiments/PEG/processed_images/test/"
# intersection.save(raw.path = path.to.raw,
#                   output.filename = "zero_intersection",
#                   treshold.set = c(20, 25, 30, 35, 40, 45, 50, 55, 60),
#                   tiff.color1 = "Alexa 555 Confocal fusion - n000000.tif",
#                   tiff.color2 = "Alexa 647 - Confocal fusion - n000000.tif")

## Stage II: run cell profiler using IPIQA, to batch create auxilary images (nuclei with outlines and cells) ####
# use configuration setting file: exemplary_before_man.xml. To learn how to run IPIQA, ask Karolina

#### Stage III: copy auxilary images to the folder of further analysis ####
path.photos.before.manual <- paste("D:/Piotrek/images/Adithya/2020-07-31-PT141_before_man/",
                                   "_555_647_before_manual/raw/data_quantify/2020-07-31-PT141_before_man/",
                                   sep = "")

View(move.photos)
move.photos(from = path.photos.before.manual,
            to = path.to.raw)

#### Stage IV: create an image stack for manual marking of nuclei ####
# The stack will consist of the following images, REGEX-matched:
dyes <- list("Sh_Nuclei", 
             "Alexa 555",
             "Alexa 647",
             "Alexa 488")

# with following contrast settings:
contrast.max <- list(80, 700, 700, 500) 
#good to adjust first, before running the analysis on all images

start <- Sys.time()
outlines.to.stack(exp.input = path.to.raw,
                  dyes = dyes, cores = 10, 
                  contrast.max = contrast.max)
end <- Sys.time()
end - start

############# Manual mark the nuclei! ################

#### Stage V create a ROI map of manual marked nuclei ####
#  roi map is an image which encodes the manually marked nuclei.
# It is next inputted into IPIQA
start <- Sys.time()
# artiicial.path.to.raw <- "D:/Piotrek/Experiments/PEG/raw_images/test/"
map.roi(exp.input = path.to.raw)
end <- Sys.time()
end - start

#### Stage VI #### Run IPIQA according to exemplary_shift_after_man.xml
# Again, ask Karolina how to run IPIQA if needed

#### Stage VII: data processing and analysis .etc ####