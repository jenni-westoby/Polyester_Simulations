library(Biostrings)
library('splatter')

#read and name command line arguments
args <- commandArgs(trailingOnly = TRUE)
mean_fragment_length<-args[1]
sd_fragment_length<-args[2]

#Load splatter counts
load("Bs_zeros_removed_25_09_param")

#Load Kallisto estimated counts from real data
Kallisto_real_data<-read.table("Kallisto_results_real_data_clean_counts.txt", header=T,row.names = 1)

#Keep only isoforms expressed in at least one cell
MaleB<-Kallisto_real_data[apply(Kallisto_real_data[,-1], 1, function(x) !all(x==0)),]

#Use lun2params to simulate gene counts
simulated_counts<-lun2Simulate(params = lun2Params, nGenes=59548)
simulated_counts<-counts(simulated_counts)

#Create new fastq of transcriptome containing only isoforms expressed in the Kallisto data
fasta = readDNAStringSet("Simulation/ref/reference.transcripts.fa")
small_fasta<-fasta[names(fasta) %in% rownames(MaleB)]
writeXStringSet(small_fasta, "polyester_transcripts")
write.table(simulated_counts, "simulated_counts.txt")

rownames(simulated_counts)<-names(small_fasta)

#make scaling vector
RPK<-vector(length=ncol(simulated_counts))
for (i in 1:length(rownames(simulated_counts))){
  #convert lengths to effective lengths
 transcript_length<-(width(small_fasta[i]))-250+1
 for (j in 1:length(RPK)){
   if (transcript_length>=1){
     RPK[j]<-RPK[j] + (simulated_counts[i,j]/transcript_length)
   }
 }
}

RPK<-RPK/1000000

for (i in 1:length(rownames(simulated_counts))){
  if (transcript_length>=1){
    simulated_counts[i,]<-(simulated_counts[i,]/transcript_length)/RPK
  }
  else{
    simulated_counts[i,]<-0
  }
}
                                
write.table(simulated_counts, "ground_truth_TPM.txt")
