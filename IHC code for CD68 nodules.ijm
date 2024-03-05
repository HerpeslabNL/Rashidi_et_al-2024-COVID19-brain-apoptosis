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
	
roiManager("reset");
run("Set Measurements...", "area mean limit display redirect=None decimal=3");
Stack.setDisplayMode("composite");	
Nuclei = "C1";
IgG = "C2";
	
name = getTitle();
shortname = substring(name,0,indexOf(name,"."));

run("RGB Color");
run("Colour Deconvolution", "vectors=[H DAB]");


//calculate the signal
setAutoThreshold("Yen");
run("Analyze Particles...", "size=1500-Infinity display include add");
