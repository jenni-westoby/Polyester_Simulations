library('splatter')
library('scran')
library('scDD')
library('pscl')

#Load Kallisto estimated counts from real data
Kallisto_real_data<-read.table("Kallisto_results_real_data_clean_countst.txt", header=T,row.names = 1)

#Load plate data
plate1<-read.table("R_data/splatter_simulations_10_7_onwards/splatter_simulation_files_2/plate1.txt", row.names=1)
plate2<-read.table("R_data/splatter_simulations_10_7_onwards/splatter_simulation_files_2/plate2.txt", row.names = 1)

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

#Function that performs simulations and outputs comparative graphs to file
simulate<-function(counts_data, lun2parameter_name){
  
  #Perform Lun2 simulation - I save this data because the program takes days to run
  lun2Params<-lun2Estimate(data.matrix(counts_data, rownames.force=TRUE), as.factor(make_plates(counts_data)), min.size=20)
 
  save(lun2Params, file=lun2_parameter_name) 
}

#Only MaleB cells with zeros removed
MaleB<-Kallisto_real_data[, -grep("MaleT", colnames(Kallisto_real_data))]
MaleB<-MaleB[apply(MaleB[,-1], 1, function(x) !all(x==0)),]

simulate(MaleB, "Bs_zeros_removed_lun2_param_18_07")
