#!/usr/bin/env bash

sed 's/\"//g' Simulation/results_matrices/Kallisto_Counts.txt | sed 's|Simulation/Kallisto_results/||g' | sed 's|/abundance.tsv||g' > Kallisto_results_real_data_clean_countst.txt
rm Simulation/results_matrices/Kallisto*
zip -r Kallisto_results_real_data_clean_countst.txt.zip Kallisto_results_real_data_clean_countst.txt
