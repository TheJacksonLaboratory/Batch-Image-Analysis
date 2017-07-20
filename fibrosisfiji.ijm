dir = getDirectory("Choose input segment Directory "); 
list = getFileList(dir);                                    // gives ImageJ a list of all files in the folder to work through
print("number of files in dir1 Segments",list.length); 


dir3= getDirectory("Choose output Directory"); 

setBatchMode(true); 


for (f=0; f<list.length; f++) {
path = dir+list[f]; 
 if (!endsWith(path,"/")) open(path);
 t=getTitle(); 

run("Duplicate...", " ");
run("Make Binary");
run("Measure");
selectWindow(t);
 
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");
run("RGB Stack");
run("Stack to Images");
imageCalculator("Divide create", "Blue","Red"); 
run("Brightness/Contrast...");
rename(t);
run("Enhance Contrast", "saturated=0.35");
run("Subtract...", "value=1.2");
run("Multiply...", "value=10000000");
run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");
run("Max...", "value=1");
run("Min...", "value=0");
run("Measure");
run("Close All");

}

selectWindow("Results");
saveAs(dir3+"fibros.txt");
	selectWindow("Log");
saveAs(dir3+"runlog.txt");