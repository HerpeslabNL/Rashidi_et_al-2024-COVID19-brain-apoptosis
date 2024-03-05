///////////////////////////////////////////////////////////////
// Macro for IgG selection on DAB Slides
// 21-02-2024 v1.0
// Author : Johan A. Slotman (j.slotman @ erasmusmc . nl)
//          Erasmus MC Optical Imaging Centre (erasmusoic.nl)
// 		  :	Seyar Rashidi
//			Department of Virosience Erasmus MC Rotterdam
//
//////////////////////////////////////////////////////////////

run("Clear Results");
run("Close All");

	
file = File.openDialog("Choose a file");
open(file);
	
dir = getInfo("image.directory");
	
close("ROI Manager");
run("Set Measurements...", "area mean limit display redirect=None decimal=3");
Stack.setDisplayMode("composite");	
Nuclei = "C1";
IgG = "C2";
	
name = getTitle();
shortname = substring(name,0,indexOf(name,"."));

run("RGB Color");
run("Colour Deconvolution", "vectors=[H DAB]");

selectWindow(IgG+"-"+name);

setThreshold(0, 254);
run("Measure");

run("Duplicate...", "namehere");
run("Auto Threshold", "method=Yen white"); 
run("Create Selection");
roiManager("Add");

selectWindow("namehere");

roiManager("Select", 0);
run("Make Inverse");
roiManager("Add");
roiManager("Select", 1);
roiManager("Rename", "BG");

roiManager("Select", 0);
setThreshold(0, 254);
run("Measure");
roiManager("Select", 1);
setThreshold(0, 254);
run("Measure");