// Macro code for batch processing a folder
// of .tif files, includes saving .tifs back into the 
// ORIGINAL folder with a modified version 
// of the original image name

 dir = getDirectory("Choose input Image Directory ");      // prompts the user to select the folder to be processed, stores the folder as the destination for saving
     list = getFileList(dir);                                             // gives ImageJ a list of all files in the folder to work through
   print(list.length);                                                      // optional prints the number of files in the folder

   dir3= getDirectory("Choose output/Roi Directory"); //promts user to select folder on Images for Anlaysis 

// Note that the above processes are outside the loop brackets {  }, so they will only be called once at the beginning of the macro


 setBatchMode(true);               // runs up to 6 times faster, without showing images onscreen.  Turn off during troubleshooting steps??
    for (f=0; f<list.length; f++) {	// main files loop (process every image until you get to the bottom of the list), { means open a loop
        path = dir+list[f];                       // creates the filepath for saving
print(path);                                      // optional prints the filepath name to a log window
        showProgress(f, list.length);     // optional progress monitor
        if (!endsWith(path,"/")) open(path);  // open the filepath
if (nImages>=1) {   // stop when there are no more images in the folder

// Not needed if folder is only tif  if (endsWith(path,"f")) {		// Processes only tif files.   Useful if there are log or metadata files in the folder  

   start = getTime();                             //optional get start time to see how long a process will take.  Goes with last line print time


   t=getTitle();    // gets the name of the image being processed   
                                     
run("RGB Color");
run("HSB Stack");
run("Stack to Images");
selectWindow("Saturation");
rename(t+ "Saturation");
setThreshold(100, 255);
roiManager("Open",dir3 +t+".zip");
n=roiManager("count");
for (i=0; i<n; i++) {
roiManager("select",t +i);
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack display redirect=None decimal=1");
run("Measure");

}
roiManager("Deselect");
roiManager("Delete");
}
    }
selectWindow("Results");
saveAs(dir3+"MME.txt");
