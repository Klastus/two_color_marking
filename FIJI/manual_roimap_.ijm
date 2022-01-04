// Create map of ROI

// Use R to iterate through each well/ 
// Each well is a subject to the following Fiji macro:


function FindImages(input, dyelist, format){
	arrayOfNames = getFileList( input );
	FoundImages = newArray();
	for(j = 0; j < dyelist.length; j++){
        for (i = 0; i < arrayOfNames.length; i++){
            if(endsWith(arrayOfNames[i], format)){
                if(indexOf(arrayOfNames[i], dyelist[j])>=0){
                    FoundImages = Array.concat(FoundImages, arrayOfNames[i]);
				}
			}
		}
	}
	return FoundImages;
}


LenOfArgs = 2;
args = getArgument();
args = split(args, ";");

if(args.length != LenOfArgs && args.length < LenOfArgs){
	print("Not enough arguments");
	exit;
}

input = args[0];
output = args[1];

/*
input = "D:/Piotrek/Experiments/PEG/raw_images/test/Well A01/";
output = "D:/Piotrek/Experiments/PEG/raw_images/test/Well A01/";
DyeList = newArray("DAPI Confocal"); //order determines colors!
*/
RoiList = newArray("RoiSet");

MatchedRoi = FindImages(input, RoiList, ".zip");


//setBatchMode(true);
if(MatchedRoi.length > 0){
    roi_path = input + "RoiSet.zip";
    roiManager("Open", roi_path);
    newImage("Labeling", "8-bit black", 5568, 4096, 1);

for (index = 0; index < roiManager("count"); index++) {
	roiManager("select", index);
	setColor(index+1);
	fill();
}
run("Select None");
resetMinAndMax();

//selectWindow("ROI Manager"); 
//run("Close"); 
} else {
	newImage("Labeling", "8-bit black", 5568, 4096, 1);
}

WorkingTitle ="Roi_map.tif";

OutputPath = output + WorkingTitle;
saveAs("Tiff", OutputPath);
run("Close All");
run("Quit");

//setBatchMode(false);

exit();

