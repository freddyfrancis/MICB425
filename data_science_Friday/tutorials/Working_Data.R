#DAY 1
#This is a comment. You should use them throughout your code to help future you as well as others understand what your code does.

#IN THE TERMINAL NOT IN R
##Pull the necessary data from the MICB425_materials folder
###Navigate to your materials folder. Your exact path may differ
cd ~/Documents/MICB425_materials
###Fetch and pull down the latest changes from GitHub
git fetch
git pull
###If you encounter issues, reset your repo to match the GitHub version.
###WARNING: this deletes any notes or changes you may have made to documents in your MICB425_materials folder
git reset --hard origin/master

##Copy the data from the MICB425_materials folder to your portfolio folder so that your portfolio R project can easily find it
cp ~/Documents/MICB425_materials/Saanich.metadata.txt ~/Documents/MICB425_portfolio/Saanich.metadata.txt

cp ~/Documents/MICB425_materials/Saanich.OTU.txt ~/Documents/MICB425_portfolio/Saanich.OTU.txt

######################################

#Now we move into R

#If you have not already, install the tidyverse which includes the dplyr package we will be using.
install.packages("tidyverse")
#Load these packages into your current R session
library(tidyverse)


#Load data
##Simply read in the data without saving or specifying any parameters
read.table(file="Saanich.metadata.txt")
##Read in the data AND save it in your R environment as a table named 'metadata'
metadata = read.table(file="Saanich.metadata.txt")
##Add parameters to format you table correctly
metadata = read.table(file="Saanich.metadata.txt", header=TRUE, row.names=1, sep="\t", na.strings=c("NAN","NA","."))

#Exercise 1: Read in the OTU table with the correct parameters
OTU = read.table(file="Saanich.OTU.txt", header=TRUE, row.names=1, sep="\t", na.strings=c("NAN","NA","."))

#When you close R, remember to save your RScript and the REnvironment!

######################################
#DAY 2
#Remember to load in your packages again!
library(tidyverse)

#General tidyverse syntax
#The pipe means "put into"
%>% 

#For example, take 'data' and put into a 'function'
##This is not R code and will not run 
data %>% function
#Is equivalent to
function(data)

#Let's begin working with real data
#Select the oxygen in uM variable (O2_uM)
  ##Select pulls out COLUMNS
oxygen = metadata %>% 
  select(O2_uM)

#Select variables with O2 or oxygen in the name
##Useful when you don't know your exact variable name
metadata %>% 
  select(matches("O2|oxygen"))

#Filter works the same way as select only it works on ROWS
#Filter rows (samples) where oxygen = 0  
metadata %>% 
  filter(O2_uM == 0)  

#At what depth is oxygen equal to 0?
##Filter the rows to only those with oxygen at 0 and then select to just see the depth variable
metadata %>% 
  filter(O2_uM == 0) %>% 
  select(Depth_m)

#Exercise 2
#Using dplyr, find at what depth(s) methane (CH4) is above 100 nM while temperature is below 10 °C. Print out a table showing only the depth, methane, and temperature data.

#Explore the data to find the exact variables names you need to use.
metadata %>% 
  select(matches("CH4|methane"))

metadata %>% 
  select(matches("temp"))

#Based on this, we know that the variables we need to use are CH4_nM and Temperature_C

#Filter to pull out rows with high methane and low temperature than select to just see these variables (columns)
metadata %>% 
  filter(CH4_nM > 100) %>% 
  filter(Temperature_C < 10) %>% 
  select(Depth_m, CH4_nM, Temperature_C)

#Several filter steps can be includes within 1 line like so
metadata %>% 
  filter(CH4_nM > 100 & Temperature_C < 10) %>% 
  select(Depth_m, CH4_nM, Temperature_C)
#Or like so
metadata %>% 
  filter(CH4_nM > 100 & Temperature_C < 10) %>% 
  select(Depth_m, CH4_nM, Temperature_C)

#The last 3 strings result in the SAME OUTPUT

#Mutate uses your current data to create a new variable
#The basic syntax is
mutate(new_variable_name = original_variable+whatever math you want to do with it)

#Create a new variable for N2O in uM instead the in nM as the original metadata has it. 
##uM = nM/1000
##This creates a new uM variable (column) at the end of the metadata
metadata %>% 
  mutate(N2O_uM_new = N2O_nM/1000)
 
#To just view the new and original N2O data, we can use select with mutate
metadata %>% 
  mutate(N2O_uM_new = N2O_nM/1000) %>% 
  select(N2O_uM_new, N2O_nM)

#Exercise 3
#Convert all variables that are in nM to μM. Output a table showing only the original nM and converted μM variables
