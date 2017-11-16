# Benchmarking_pipeline

Prerequisites:

-virtualenv

-github account

-reference genome gtf and fasta files. Note that if your data contains ERRCC spike-ins, you should concatenate the reference genome gtf file with the ERRCC gtf file, and concatenate the reference and ERRCC fastq files (see https://tools.thermofisher.com/content/sfs/manuals/cms_095048.txt)

-directory containing single cell RNA-seq data. This data should be demultiplexed, have any adaptors trimmed and should be in the format of gzipped fastq files.

To run the pipeline:

1. Execute ./setup.sh setup. This will create a new directory called Simulation into which all the software required for this pipeline will be locally installed. In addition, empty directories are created within the Simulation directory which will eventually contain the RSEM references, various indices, the raw and simulated data, results matrices and graphs. This step will take ~30 minutes - 1 hour depending on your network speed.

2. Execute ./RSEM_ref.sh make_ref /path/to/gtf path/to/fasta, where the gtf and fasta files are the reference genome. This builds the RSEM reference.

3. Execute ./benchmark_real.sh benchmark Kallisto /path/to/data to generate counts data for Kallisto from real data.

4. Execute ./quality_control.sh QC path/to/gtf path/to/fasta path/to/raw/data. This creates a table of quality control statistics. Based on the results of this you can decide which cells you would like to simulate and which you are going to discard.

5. Execute ./make_matrix.sh make_matrix Kallisto_real.

6. Execute ./clean_up_real.sh.

7. Execute Rscript make_splatter.R . Note that this step took ~1 week to execute on my desktop computer and in practice was too slow to run on the LSF jobs system I had access to for queuing reasons. Note also that this step requires plate data - the BLUEPRINT plate data in this directory (plate1.txt and plate2.txt) is used as a default.

8. Once you have decided which cells to discard and have a directory containing only the gzipped cells you want to simulate, execute ./control_polyester_script.sh. The simulated cells and their ground truth expression values are saved in Simulation/data/simulated. You can change the bias option in make_polyester.R to change whether or not to simulate 3' coverage bias - see the polyester manual. The script in this repository simulates uniform coverage.

9. Download BBTools and follow the installation instructions at https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/reformat-guide/. Execute the following to copy the simulated fasta files into the Simulation/data/simulated directory, then convert the files to fastq format:

```
cd Simulation/data

for file in simulated*[0-9];
do
  number=`echo $file| awk -Fd '{print $2}'`
  cp $file/sample_01_1.fasta simulated/sample_$number"_1.fasta"
  cp $file/sample_01_2.fasta simulated/sample_$number"_2.fasta"
done

cd ../..
for file in Simulation/data/simulated/sample*_1.fasta;
do
  filepath=`echo $file | awk -F_ '{print $1"_"$2}'`
  ./bbmap/reformat.sh in1=$filepath"_1.fasta" in2=$filepath"_2.fasta" out1=$filepath"_1.fq" out2=$filepath"_2.fq" qfake=30
done
```

10. If you wish, you can also perform quality control on your simulated cells based on read and alignment quality. This is probably wise, as RSEM sometimes generates cells with very few reads. Execute ./quality_control.sh QC path/to/gtf path/to/fasta and delete any problematic cells from the data/simulated directory.

11. Execute ./benchmark.sh benchmark name_of_program_you_want_to_test. This will generate results matrices of expression values for the method you are interested in. Repeat for each method you want to test.

12. Execute ./make_matrix.sh make_matrix name_of_program_you_want_to_test. This generates a compact results matrix for each method in results_matrices.

13. Execute ./clean_data.sh to trim filename paths from results matrix column names.
