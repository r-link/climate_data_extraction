###############################################################################
#
#  Get and process CRU data ------
#
#  Contact: roman.link@plant-ecology.de
#
###############################################################################

# 1. Load packages ------------------------------------------------------------
# Please make sure that GDAL is available, else many of the functions here will
# not work! https://gdal.org/download.html

# DWD data are accessed through Berry Boessenkool's rdwd package. It is recommended
pacman::p_load(cruts, raster, tidyverse)

# load dirtree script for plotting directory trees
source("R/dirtree.R")

# 2. Prepare download of DWD rasters ------------------------------------------
# download rasters here: https://crudata.uea.ac.uk/cru/data/hrg/
# reference https://www.nature.com/articles/s41597-020-0453-3

# read downloaded raster file with cruts::cruts2raster
PET <- cruts2raster("CRUTSdata/cru_ts4.04.1901.2019.pet.dat.nc",
                    timeRange = c("2000-01-01", "2010-01-01"))
# (note that errors can arise when no time range is given!)

plot(PET)
# this raster stack can be used to extract observations for samples using 
# raster::extract() etc.