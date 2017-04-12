arg = getArgument()
print("Full argument" +arg)
dir=split(arg," ");

FS="/";

for (i=0; i<dir.length; i++) {
     //print(substring(dir[i],5));
     addToArray(substring(dir[i],5), dir, i);
     print(dir[i]);
}

print("Execute batch from directory: "+dir[0]);
print("Execute batch from directory: "+dir[1]);
print("Execute batch from directory: "+dir[2]);


print("start directoryQC outside loop");


list = getFileList(dir[0]);  // gives ImageJ a list of all files in the folder to work through
extension1 = ".tiff"
print("number of files in dir[0] Segments",list.length);    

list2 = getFileList(dir[1]);                 // gives ImageJ a list of all files in the folder to work through for directory2 
extension2 = ".tif";   //defines file type  variable 
print("number of files in dir[1] Image",list2.length);        


setBatchMode(true);               // runs up to 6 times faster, without showing images onscreen.  Turn off during troubleshooting steps??
 
 dbugp = 1;		

 listerrs=0;
    for (f=0; f<list.length; f++) {
imageID = substring( list[f], 0,15);
print ("imageID",imageID);

listerrs=0;
    for (f=0; f<list.length; f++) {
imageID = substring( list[f], 0,13);
print ("imageID",imageID);
//testindx =  indexOf("123456789","456");
//print("testindx=",testindx);
Imdx= indexOf( list2[f],imageID);
print("value of Index",Imdx);

if (Imdx <0 ) { // if list2[f] does not contain same imageID as list[f]
print("List Compare Error:");
print ( "   dir[0]  file#",f," = ", list[f] );
print ( "   dir[1] file#",f," = ", list2[f] );
listerrs++;  // count the errors
}
}
if(listerrs > 0 ) { exit(); }

print("START...");
for (f=0; f<list.length; f++) {
        path = dir[0]+list[f]; 
        if(dbugp>0) {	 // optional prints the path & file name to a log window
			print("Name of path reading file from dir[0]",path); 
			}


		open(path);
    
         t=getTitle();    // gets the name of the image being processed   

       

			if(dbugp>0) {
				print("getTitle got t=", t ); 
				}	
			tt = substring(t,0,13); // Shortens title from start to X characters (t,0,X)
			if(dbugp>0) {
				print("attempt to truncate t=", tt ); 
				}


			run("Enhance Contrast...", "saturated=1 normalize");
			print("Enhance contracst");
			setAutoThreshold("Default dark");
			print("autoThreshold");
			//run("Threshold...");
			//setThreshold(129, 255);
			setOption("BlackBackground", false);
			print("setoption");
			run("Convert to Mask");
			print("Mask");
			run("Gaussian Blur...", "sigma=10");
			print("Gaussianblurr");
			run("Make Binary");
			print("Make binary");
			run("Analyze Particles...", "size=4000-Infinity");
			Overlay.copy
			print("Ananlyze particles function ran");
			path2=dir[1]+FS+list2[f]; 
			print("Name of path reading files from dir[1]",path2);   
			if (indexOf(path2,tt)>0) {
			open(path2); 
			run("RGB Color");
			print("name of filefor dir2RGBrun step",tt);
			run("HSB Stack");
			run("Stack to Images");
			selectWindow("Saturation");
			rename(t+ "Saturation");
			setThreshold(80, 255);
			Overlay.paste
			run("Measure");
			for (i=0;i<Overlay.size;i++){			
				Overlay.activateSelection(i);
				List.setMeasurements;
				var1=getResult("%Area",nResults-1);
				print( "Number of Var ",tt,"\t",var1);
						}
			}else 
			print(error);										
							saveAs("Results",dir[2]+tt+"MME.csv");
}
						
							}
					
						Overlay.clear;
		
				
	




function addToArray(value, array, position) {
	if (position<lengthOf(array)) {
		array[position]=value;
	} else {
		temparray=newArray(position+1);
		for (i=0; i<lengthOf(array); i++) {
			temparray[i]=array[i];
		}
		temparray[position]=value;
		array=temparray;
	}
	return array;
}

//Appends the value to the array
//Returns the modified array
function appendToArray(value, array) {
	temparray=newArray(lengthOf(array)+1);
	for (i=0; i<lengthOf(array); i++) {
		temparray[i]=array[i];
	}
	temparray[lengthOf(temparray)-1]=value;
	array=temparray;
	return array;
}
