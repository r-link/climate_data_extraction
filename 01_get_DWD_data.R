###############################################################################
#
#  Get and process DWD data ------
#
#  Contact: roman.link@plant-ecology.de
#
###############################################################################

# 1. Load packages ------------------------------------------------------------
# Please make sure that GDAL is available, else many of the functions here will
# not work! https://gdal.org/download.html

# DWD data are accessed through Berry Boessenkool's rdwd package. It is recommended
# to install the development version from github as it contains the newest index
# files
remotes::install_github("brry/rdwd")

pacman::p_load(rdwd, raster, tidyverse)

# load dirtree script for plotting directory trees
source("R/dirtree.R")

# 2. Prepare download of DWD rasters ------------------------------------------
# The "gridIndex" contains a list of all raster files on the DWD OpenData server
# https://opendata.dwd.de/climate_environment/CDC/
data("gridIndex")
head(gridIndex)

# The data structure on this server is highly idiosyncratic. The easiest way to
# get what you want is taking the gridIndex and filtering out the files you need
# using string search and regular expressions.
# you can explore the dwd website to find out how to subset or use the rudimentary
# dirtree() function i made to explore the dataset
dirtree(gridIndex, level = 2)

# for instance, you can start by having a look at the monthly measurements
str_subset(gridIndex, "monthly") %>% 
  dirtree(level = 2, max_files = Inf)

# ...or peek into the january precipitation datasets to find out how they are organized
str_subset(gridIndex, "monthly") %>% 
  str_subset("precipitation") %>% 
  str_subset("01_Jan") %>% 
  dirtree(level = 4, max_files = Inf)

# as a first trial, we might want to get all monthly precipitation, PET and temperature
# grids from 2010 onwards
prec <- str_subset(gridIndex, "monthly") %>% 
  str_subset("precipitation") %>% 
  str_subset("_201|_202")

temp <- str_subset(gridIndex, "monthly") %>% 
  str_subset("air_temp_mean") %>% 
  str_subset("_201|_202")

PET <- str_subset(gridIndex, "monthly") %>% 
  str_subset("evapo_p") %>% 
  str_subset("_201|_202")

# like this...
dirtree(prec, level = 4, max_files = Inf)
dirtree(temp, level = 4, max_files = Inf)
dirtree(PET, level = 4, max_files = Inf)

# 3. Download precipitation and temperature rasters ---------------------------
precfiles <- dataDWD(prec, base = gridbase, joinbf = TRUE)
tempfiles <- dataDWD(temp, base = gridbase, joinbf = TRUE)
petfiles  <- dataDWD(PET,  base = gridbase, joinbf = TRUE)

# The files are now loaded on the hard disk and can be stacked and used to extract
# observations for plot coordinates. Or you can load them in a new script with readDWD()
