# Benchmarking_pipeline

Prerequisites:

-virtualenv

-github account

-reference genome gtf and fasta files. Note that if your data contains ERRCC spike-ins, you should concatenate the reference genome gtf file with the ERRCC gtf file, and concatenate the reference and ERRCC fastq files (see https://tools.thermofisher.com/content/sfs/manuals/cms_095048.txt)

-directory containing single cell RNA-seq data. This data should be demultiplexed, have any adaptors trimmed and should be in the format of gzipped fastq files.

Note: If you are running this pipeline on the BLUEPRINT B lymphocyte single cell data, after step 2 you can skip to step 7.

To run the pipeline:

1. Execute ./setup.sh setup. This will create a new directory called Simulation into which all the software required for this pipeline will be locally installed. In addition, empty directories are created within the Simulation directory which will eventually contain the RSEM references, various indices, the raw and simulated data, results matrices and graphs. This step will take ~30 minutes - 1 hour depending on your network speed.

2. Execute ./RSEM_ref.sh make_ref /path/to/gtf path/to/fasta, where the gtf and fasta files are the reference genome. This builds the RSEM reference.

3. Execute ./benchmark_real.sh benchmark Kallisto /path/to/data to generate counts data for Kallisto from real data.

4. Execute ./make_matrix.sh make_matrix Kallisto.

5. Execute ./clean_up_real.sh.

6. Execute Rscript make_splatter.R . Note that this step took ~1 week to execute on my desktop computer and in practice was too slow to run on the LSF jobs system I had access to for queuing reasons.

7. Once you have decided which cells to discard and have a directory containing only the gzipped cells you want to simulate, execute *fill in polyester command*. The simulated cells and their ground truth expression values are saved in Simulation/data/simulated.

8. If you wish, you can also perform quality control on your simulated cells based on read and alignment quality. This is probably wise, as RSEM sometimes generates cells with very few reads. Execute ./quality_control.sh QC path/to/gtf path/to/fasta and delete any problematic cells from the data/simulated directory.

9. Perform any further quality control you would like to perform prior to doing your benchmarking. For example, I use the scater package to filter based on patterns of expression, such as unusually high percentages of ERCCs. For this analysis I use the ground truth expression values produced in the simulation.

10. Before performing the quantification step, delete any cells that you don’t want to include in the benchmarking.

11. Execute ./benchmark.sh benchmark name_of_program_you_want_to_test. This will generate results matrices of expression values for the method you are interested in. Repeat for each method you want to test.

12. Execute ./make_matrix.sh make_matrix. This generates a compact results matrix for each method in results_matrices.
