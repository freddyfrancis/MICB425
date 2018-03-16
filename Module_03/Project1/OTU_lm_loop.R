# Remove the otu_stats object so upon rerunning doesn’t add to existing object
rm(otu_stats)
# Create new data frame to hold linear model outputs
otu_stats = data.frame("Estimate" = numeric(0), "Std. Error"= numeric(0),"t value"= numeric(0),"Pr(>|t|)"= numeric(0))

#Run a loop across your row names from a table of your otu/asv table filtered to just those within your taxon of interest. In this script, this table is named "m.filtered".
for (otu in row.names(m.filtered)){
#Make sure necessary packages are loaded
  require(tidyverse)
  require(knitr)
#Run a linear model of 1 OTU against depth
    linear_fit = m.norm %>% 
    psmelt() %>% 
    filter(OTU==otu) %>% 
    
    lm(Abundance ~ Depth_m, .) %>% 
    summary()
#Pull out the coefficients and p-values for depth
  otu_data = linear_fit$coefficients["Depth_m",]
#Add these values to a growing table of OTUs
  otu_stats <- rbind(otu_stats, otu_data)
}
#Rename columns of output table
colnames(otu_stats)<- (c("Estimate", "Std. Error","t value","Pr(>|t|)"))

#Apply row names from the m.filtered data to the lm output table
row.names(otu_stats) <- row.names(m.filtered)

#Print table
kable(otu_stats,caption="Correlation data of OTUs within Chloroflexi phylum across depth")