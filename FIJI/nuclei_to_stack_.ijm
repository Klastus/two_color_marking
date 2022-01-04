// Create a stack of 3 images: two CellTrace channel 
// and outlines of nuclei from CellProfiler pipeline

// Use R to iterate through each well/ 
// Each well subject to the following Fiji macro.


function FindImages(input, dyelist){
	arrayOfNames = getFileList( input );
	FoundImages = newArray();
	for(j = 0; j < dyelist.length; j++){
        for (i = 0; i < arrayOfNames.length; i++){
            if(endsWith(arrayOfNames[i],".tif")){
                if(indexOf(arrayOfNames[i], dyelist[j])>=0){
                    FoundImages = Array.concat(FoundImages, arrayOfNames[i]);
				}
			}
		}
	}
	return FoundImages;
}


LenOfArgs = 4;
args = getArgument();
args = split(args, ";");

if(args.length != LenOfArgs && args.length < LenOfArgs){
	print("Not enough arguments");
	exit;
}


input = args[0];
output = args[1];
DyeList = split(args[2], ",");
max = split(args[3], ",");
/*well = split(args[1], "/");
well = well[well.length-1];

input = "D:/Piotrek/Experiments/PEG/raw_images/2019-07-11-PT79_inter/2019-07-11_000/Well A01/";
output = "D:/Piotrek/Experiments/PEG/raw_images/2019-07-11-PT79_inter/2019-07-11_000/Well A01/";
DyeList = newArray("Sh_Nuclei", "Alexa 555", "Alexa 647", "Alexa 488"); //order determines colors!
max = newArray(150, 1000, 1000, 300);
*/
MatchedFiles = FindImages(input, DyeList);
min = 0;

/*
max = 400;
*/


setBatchMode(true);
for( image=0; image < MatchedFiles.length; image++){
    open(input + MatchedFiles[image]);
	if(indexOf(MatchedFiles[image], DyeList[0])>=0){
    setMinAndMax(min, max[0]);
	} else if(indexOf(MatchedFiles[image], DyeList[1])>=0){
	setMinAndMax(min, max[1]);
	} else if(indexOf(MatchedFiles[image], DyeList[2])>=0){
        setMinAndMax(min, max[2]);
	} else if(indexOf(MatchedFiles[image], DyeList[3])>=0){
        setMinAndMax(min, max[3]);
	}
}
    if(DyeList.length>2){
    ConcatenateCommand = "image1=[" + MatchedFiles[0] + "] image2=[" + MatchedFiles[1] + "] image3=[" + MatchedFiles[2] + "] image4=[" + MatchedFiles[3] + "]";  
     } else {
    ConcatenateCommand = "image1=[" + MatchedFiles[0] + "] image2=[" + MatchedFiles[1] + "] image3=[" + MatchedFiles[2] + "]";     
     }
	WorkingTitle ="nuclei_stack.tif";
    run("Images to Stack", ConcatenateCommand);
    /*run("Images to Stack", "name=Stack title=[] use");*/

	OutputPath = output + WorkingTitle;
	saveAs("Tiff", OutputPath);
	run("Close All");
	

setBatchMode(false);

exit();

