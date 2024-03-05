///////////////////////////////////////////////////////////////
// Macro for quantification of fluorescent cells in tissue
// 21-02-2024 v1.0
// Author : Johan A. Slotman (j.slotman @ erasmusmc . nl)
//          Erasmus MC Optical Imaging Centre (erasmusoic.nl)
// 		  :	Seyar Rashidi
//			Department of Virosience Erasmus MC Rotterdam
//
//////////////////////////////////////////////////////////////

//set required measurments
run("Set Measurements...", "area mean min centroid center integrated redirect=None decimal=3");

dir = getDirectory("Choose a directory");
files = getFileList(dir);

for(iii=0;iii<files.length;iii++){
	
	//clean up FIJI workspace
	run("Clear Results");
	run("Close All");
	
	//run the algorithm only on tif files
	if(endsWith(files[iii],".tif")){
		
		open(files[iii]);		
		roiManager("reset");
		
		//define channels containing DAPI, TUNEL and proteins of interest 1 and 2
		dapi = "C1";
		TUNEL = "C2";
		pr1 = "C3";
		pr2 = "C4";		
		
		name = getTitle();
		shortname = substring(name,0,indexOf(name,".")); //title without extension
		
		run("Split Channels");
		selectWindow(dapi+"-"+name);
		run("Gaussian Blur...", "sigma=2");
		setAutoThreshold("Triangle dark");
		run("Create Mask");
		run("Watershed");
		run("Analyze Particles...", "display exclude include");
		Table.sort("Area");
		AreaNuc = getResult("Area",floor(nResults/2)); //get median area of a nucleus
		run("Clear Results");
		run("Create Selection");
		run("Measure"); // measure area of all nuclei 
		run("Create Mask");
		rename("DapiMask");
		Area = getResult("Area",0);
		
		
		//remove background from TUNEL image by substracting median filtered image	
		run("Clear Results");
		selectWindow(TUNEL+"-"+name);
		run("Duplicate...", "title=median");
		run("Median...", "radius=15");
		imageCalculator("Subtract create", TUNEL+"-"+name,"median");
		rename("filtered");		
			
				
		run("Select None");
		setThreshold(90,255); //fixed threshold of 90 is used
		run("Analyze Particles...", "size=30-Infinity pixel show=Nothing display exclude include add");
		roiManager("Combine");
		run("Create Mask");
		rename("TUNELmask");
		imageCalculator("AND create", "TUNELmask","DapiMask"); //create a mask of areas positive for both DAPI and TUNEL
		rename("TUNELresults");
		setThreshold(1, 255); //select mask
		
		//create squares for each TUNEL positive cell and set type to 0
		nROI = roiManager("count");
		xs = newArray(nROI);
		ys = newArray(nROI);
		ws = newArray(nROI);
		hs = newArray(nROI);
		type = newArray(nROI);
					
		for(i=0;i<nROI;i++){
			
			roiManager("select", i);
			getSelectionBounds(x, y, width, height);
			cx = x + (width/2);
			cy = y + (height/2);
		
			xs[i]=cx;
			ys[i]=cy;
			
			width = width * 1.5;
			height = height * 1.5;
		
			ws[i] = width;
			hs[i] = height;
		
			type[i] = 0;		
				
		}
		
		roiManager("reset");
		run("Select None");
		run("Analyze Particles...", "pixel display exclude clear include add");
		numCells = nResults; //DAPI + TUNEL positive nuclei
		run("Clear Results");		
		selectWindow(TUNEL+"-"+name);
		roiManager("Combine");
		run("Create Mask");
		rename("Mask1"); 
		
		channel = newArray(pr1,pr2);
		perc = newArray(0.50,0.50); //precentage of overlap of protein with DAPI+TUNEL positive nuclei for positive signal
		thr_constant = newArray(30,40); //threshold for pr1 and pr2 respectively
		thr_mult = newArray(2,4); //Factor applied to background for pr1 and pr2 respectively	
		pos_celmarker = newArray(2);
		for(ch = 0; ch < channel.length; ch++){
			selectWindow(channel[ch]+"-"+name);
			run("Gaussian Blur...", "sigma=2");
			bg = getBackground(); //background defined as mean signal of 30x30 pixel square with lowest mean intensity in the image
			setThreshold((thr_constant[ch]+(bg*thr_mult[ch])),255 ); //threshold is set as fixed threshold plus x times the background
			run("Create Selection");
			run("Create Mask");
			rename("Mask"+channel[ch]);
			imageCalculator("AND create", "Mask1","Mask"+channel[ch]); //make mask of TUNEL and Protein of interest positive cells
			rename("results_"+channel[ch]);
			run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1.0000000"); //work with unscaled values
			roiManager("Measure");
			pos_celmarker[ch] = 0;
			for(i=0;i<nResults;i++){
			
				a = getResult("Area",i);
				intDen = getResult("IntDen",i);
			
				setResult("totalIntDen",i,a*255);
				setResult("perc",i,intDen/(a*255));
		
				centerx = getResult("XM",i);
				centery = getResult("YM",i);
				mindist = 10000*10000; 
				mindistindex = 1000000;
			
				if(intDen/(a*255) > perc[ch]){ //cell is positive is overlap is higher than given percentage
					pos_celmarker[ch]++;
		
					for(j=0;j<xs.length;j++){
						dist = pow(xs[j]-centerx,2)+pow(ys[j]-centery,2);
						if(dist < mindist){
							mindist = dist;
							mindistindex = j;
						}
						
					
					}
					
					type[mindistindex] = type[mindistindex]+(ch+1);	//change type of cell 		
					
				}
				
			}
			
			run("Clear Results");
		}
		
		
		//calculate results and print to log file
		totalchannelspec = newArray(2);
		sizes = newArray(30,0);
		sizesMax = newArray("Infinity","Infinity");	
		for(ch=0;ch<channel.length;ch++){
			imageCalculator("AND create", "DapiMask","Mask"+channel[ch]);
			rename("Result_Dapi_"+channel[ch]);
			setThreshold(1,255 );
			run("Analyze Particles...", "size="+sizes[ch]+"-"+sizesMax[ch]+" pixel show=Nothing clear display exclude include");
			totalchannelspec[ch] = nResults;
			
		}
		
		if(iii==0){
			print("Name \t Dapi \t DapiTunel \t Dapi"+channel[0]+" \t Dapi"+channel[1]+" \t Dapi"+channel[0]+"TUNEL \t Dapi"+channel[1]+"TUNEL");
		}
		print(""+shortname+" \t "+floor(Area/AreaNuc)+" \t "+numCells+" \t "+totalchannelspec[0]+" \t "+totalchannelspec[1]+" \t "+pos_celmarker[0]+" \t "+pos_celmarker[1]);
		
		
		//draw squares around nuclei with specific color for each type
		
		for(i=0;i<xs.length;i++){
				
				x = xs[i] - (ws[i]/2);
				y = ys[i] - (hs[i]/2);
				if(type[i]==0){
					setColor(245,245,245);
				}
				if(type[i]==1){
					setColor(216,179,101);
				}
				if(type[i]==2){
					setColor(90,180,172);
				}
				if(type[i]==3){
					setColor(255,255,153);
				}
				
				Overlay.drawRect(x, y, ws[i], hs[i]);
				Overlay.add;
				Overlay.show();
				Overlay.setStrokeWidth(2);
		}
		
		//cleanup and save overlay as rois 
		
		close("ROI Manager");
		run("To ROI Manager");
		roiManager("Save", dir+shortname+"_overlay.zip");
		run("Close All");
		
	}

}


//background determining function

function getBackground(){

	xSize = 30;
	ySize = 30;
	
	getDimensions(width, height, channels, slices, frames);
	
	xStep = floor(width/xSize);
	yStep = floor(height/ySize);
	
	minMean = 300;
	cummax = 0;
	n = 0;
	
	for(x=0;x<xStep;x++){
		for(y=0;y<yStep;y++){
			makeRectangle(x*xSize,y*ySize,xSize,ySize);
			getStatistics(area, mean, min, max, std, histogram);
			if(mean<minMean){
				minMean = mean;		
			}
			
			cummax = cummax + max;
			n = n + 1;
		}
	}
	
		
	return(minMean);

	
}




	
