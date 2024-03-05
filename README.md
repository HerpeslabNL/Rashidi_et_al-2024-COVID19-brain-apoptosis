# Apoptosis is identified as the primary mechanism of cell death in the medulla oblongata of COVID-19 patients

This study aims to elucidate the role of programmed cell death (PCD) in COVID-19-associated neuropathogenesis within brainstem specimens. The goal is to uncover the mechanisms underpinning neurological complications linked to COVID-19, enhancing our understanding of SARS-CoV-2-associated diseases.

![ErasmusMC Logo](logo.png)

# Authors
Johan A. Slotman (j.slotman@erasmusmc.nl), Erasmus MC Optical Imaging Centre (erasmusoic.nl)
Seyar Rashidi, (a.rashidi@erasmusmc.nl) Department of Viroscience Erasmus MC Rotterdam

# Installation and Usage Instructions
To use the scripts, ensure ImageJ software (version 1.53t, National Institutes of Health, Bethesda, MD, USA) is installed. You can download it from FIJI or ImageJ:https://fiji.sc/ or at https://imagej.net/ij/download.html 

All image analyses were conducted using ImageJ software (version 1.53t). Specific scripts were crafted to quantify distinct brain cell types (neurons, microglia, hematopoietic cells, oligodendrocytes, macrophages) and the cell death marker (TUNEL). The scripts, coded in ImageJ Macro Language (IJM), are compatible with FIJI. Open the .ijm file in FIJI by dragging and dropping it into the main menu, launching the .ijm script editor.

# Method Details

This script is tailored for multiplex immunofluorescence images, supporting .LIF files from Leica imaging software. It enumerates nucleated cells (identified by nucleic acid stain like Hoechst/DAPI) and a second cell population (measured by surface markers such as MAP2, OLIG2, Iba-1, CD45), addtionally combined with/without a cell death marker (TUNEL). The script provides metric distance area measurements for the image selection.

Quantification examples are presented in Fig. 1B-C & F (left panel) (CD45 and Iba-1 positive nucleated cells), Fig. 2C (TUNEL positive nucleated cells), Fig. 3B-C (MAP-2, OLIG2, CD45, or Iba-1 positive TUNEL cells). For IHC images, NDPI images can be directly opened in FIJI, and channels separated and quantified based on the expression of the proteins of interest (surface markers like IgG or CD68). These figures are illustrated in Fig. 1D-E and F (right panel). The code is adaptable within the .ijm script editor.

# Files
IF code for Hoechst TUNEL CD45 Olig2.ijm
IF code for Hoechst TUNEL Iba1 MAP2.ijm
IHC code for IgG.ijm
IHC code for CD68 nodules.ijm


# Provisional Citation
Rashidi AS, Dis VV, Slotman JA, Bosch TVD, Verdijk RM, Gent MV, Verjans GMGM (2024): Apoptosis is the main cause of cell death in the medulla oblongata of COVID-19 patients.