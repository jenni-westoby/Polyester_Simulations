#!/usr/bin/env bash

sed 's/\"//g' Simulation/results_matrices/Kallisto_real_Counts.txt | sed 's|Simulation/Kallisto_results_real_data/||g' | sed 's|/abundance.tsv||g' > Kallisto_results_real_data_clean_counts.txt

zip -r Kallisto_results_real_data_clean_counts.txt.zip Kallisto_results_real_data_clean_counts.txt
