setwd("~/data/splatter_simulation_files_2")
library('splatter')
library('scran')
library('scDD')
library('pscl')

#Load Kallisto estimated counts from real data. Note, this script was written for the BLUEPRINT B lymphocytes and assumes only the B lymphocytes are present in the input data
MaleB<-read.table("Kallisto_results_real_data_clean_counts.txt", header=T,row.names = 1)

#Load plate data
plate1<-read.table("plate1.txt", row.names=1)
plate2<-read.table("plate2.txt", row.names = 1)

#Function that formats plate data 
make_plates<-function(counts_data){
  plates<-colnames(counts_data) %in% rownames(plate1)
  for (i in 1:length(plates)){
    if (plates[i]==TRUE){
      plates[i]<-'positive'
    }
    else{
      plates[i]<-'negative'
    }
  }
  return(plates)
}

#Only MaleB cells with zeros removed
MaleB<-MaleB[apply(MaleB[,-1], 1, function(x) !all(x==0)),]

#Perform Lun2 simulation - I save this data because the program takes days to run
lun2Params<-lun2Estimate(data.matrix(MaleB, rownames.force=TRUE), as.factor(make_plates(MaleB)), min.size=20)

save(lun2Params, file="Bs_zeros_removed_25_09_param") 
