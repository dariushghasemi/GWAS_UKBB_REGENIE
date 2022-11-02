# GWAS_UKBB_REGENIE
Running GWAS on Kidney's latent phenotypes via REGENIE v3.1.3.gz!

- In qcUKBB.sh you'll find the commands for format conversion of UKBB genotype file (BGEN) using plink.

- Fo Step 1 of GWAS via REGENIE, we need a merged file contating all the genotypes from autosomes (chromosome 1 to 22) in one single file in BGEN or plink{.bed/.bam/.fam) formats. 

- To prepare such file, we are using plink to to convert the BGEN files to plink and meanwhile impose our criteria for filtering SNPs based on their Minor Allele Frequency (MAF) and Allel Count (AC).

- Before merging the converted plink files, we need to store their names in text file, here called "myfilesnames.txt".

- Then, we use plink2 to merged the QC-ed plink files. This merged file consisting all the the autosomes genotypes is going to be used for step1 of GWAS using REGENIE where we need to find the most important SNPs across all SNPs of the study to make a prediction file for Step 2 of GWAS.

- File format conversion using plink2 was unsuccessful! Plink couldn't merge multiallelic SNPs positions using genotype input in plink format. -> Jobs were finished on June 25, 2022.

- I now move on by taking the alternative approach which utilizes bgenix tool to convert the genotype files from BGEN to VCF file. One can also makes use of plink2 to conduct the conversion if they don't have bgenix installed on their Unix machine. (As in parallel I tested BGEN to VCF format conversion via Plink2 -also filtered SNPs based on MAF/MAC- and it worked too.)

- Additionally, I directly piped the converted file in VCF format to vcftools for pruning SNPs by MAF/MAC, and then to bcftools for reheadering file. So, they all worked well.

- It's been around one week and the submitted slurm-jobs with 4 seperate CPUs and mem-per-cpu=16Gb are still being done on the EURAC servers!!! This just file format conversion and initial SNPs pruning (QC process)!!! GWAS is remained!!! -> Jobs were started on June 29, 2022 and were finished at 20:12' on July 4, 2022.

- I found that Bgenix is not suitable for BGEN->VCF format conversion when there are some multiallelic regions in your genotype file. Multiallelic SNPs put the files conversion into trubble. So, we need an alternative tool which is plink2 in this case in order to do the conversion.

- I'm dubious wheather bgenix could have correctly converted the bgen files to VCF, as I have found small number of SNPs remained for some of the CHRs after filtering SNPs (MAF05/AC10)! 

- I'm now trying again to convert BGEN->VCF with Plink2 and compare the generated VCF file with the bgenix VCF file for the same CHR in terms of size, number of SNPs, and etc. -> Jobs were finished at 13:43' on July 12, 2022.

- Persumabley the CHRs have been correctly converted to VCF file using Plink2.

- Now we can merge the QCed VCF files and run the first step of REGENIE GWAS. First I need to check and test the VCFmerge function for CHR21 and CHR22. If it worked, I would stick to it and proceed for Step 1 of REGENIE GWAS.

- By double checking the samples number in the merged VCF file, Dosage levels, and some of the other factors in the merged VCF file, we can carry on towards Step1.

- But there is still one last step in preparation of the genotype file which is changing the merged VCF file to BGEN and indexing it. 

- We re-converted again the merged VCF file (but nor separate ones) into a signle BGEN file and used bgenix to index it.

- Now that I'm writing, we ran the Step1 of the GWAS using REGENIE using the paameters in this script file "GWAS_Regenie_step1.sh".

- Step1 needs a sample file containing all the sample IID and FIDS, exactly like mentione don the documentation website of the REGENIE, where I used bcftools to query them (n=371,535). and modified it to make it compatible with REGENIE desired format.

- Step1 is now running using slow partition on the EURAC servers and the results of the it (prediction files) would be ready in a couple of hours (Started on Wednesday 18:50, August 8, 2022 --- Finished on Friday 14:29, August 12, 2022).

- We now set up step 2 (association tests) and lunch the jobs at servers using slurm (Started on Friday 18:50, August 12, 2022 --- Finished on Friday 01:23, August 13, 2022).

- You can generate qqplot.R to generate the quality control plots simultaneously for the GWAS summary results of Pheno1 and Pheno2 using these commands:

```bash
./qqplot.R ~/projects/UKBB_Ryo/output/step2_UKBB_Pheno1_with_AGE_SEX_PCs_firth_Pheno1.regenie.gz Pheno1 ~/projects/UKBB_Ryo
./qqplot.R ~/projects/UKBB_Ryo/output/step2_UKBB_Pheno1_with_AGE_SEX_PCs_firth_Pheno2.regenie.gz Pheno2 ~/projects/UKBB_Ryo
```

- Having looked at the MH and QQ plots, we can proceed to run the GWAS analysis on the entire chromosomes. But this time we like to make use of the [NextFlow pipeline](https://github.com/genepi/nf-gwas) to make our life easier before and after running GWAS.

- We have still problem with format conversion for CHR2. Plink2 returns an error and cannot ern the pgen to vcf file (31 August, 2022). Made a mistake. The file was converted on Aug 25.

- I've realized the header columns (perhaps individuals id was corropted for CHR12 which was primarily converted to VCF and QC-ed using Bgenix). It means that we need to reconvert the rest of the CHRs, 12 to 20, using the same tool Plink2 for homoginity (12 September, 2022).
```bash
cat out2VCFbyPlink.txt | tail -2 | sarrayscript -c 4 --mem-per-cpu 65536 -J 2VCF
```

- Reconversion of all incorrupted CHR files were finished. Index files were also created (13 September, 2022).

- Now, vcf merge is running using 6 CPU and 16GB RAM once at a time (14-16 September, 2022).
```bash
#Rename the VCF file names
for chr in {1..22}; do mv /scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr${chr}_v3_pruned_MAF.05_MAC10.vcf.gz /scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr${chr}_v3_pruned_MAF05_MAC10.vcf.gz; done
#Rename the VCF index file names
for chr in {1..22}; do mv /scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr${chr}_v3_pruned_MAF05_MAC10.vcf.gz.tbi$chr /scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr${chr}_v3_pruned_MAF05_MAC10.vcf.gz.tbi; done
#Storing the VCF file names
for chr in {1..22}; do echo '/scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr'${chr}'_v3_pruned_MAF05_MAC10.vcf.gz'; done >> /scratch/UKBB/imputed-500k_V3/test/myVCFnames.txt
#Generating the commands for file conversion
echo bcftools concat -Oz $(paste -sd '\t' myVCFnames.txt)  -o /scratch/UKBB/imputed-500k_V3/test/ukb_imp_allCHRs_v3_pruned_MAF05_MAC10.vcf.gz > outVCFmerge.txt
#Run the commands on servers
cat outVCFmerge.txt | sarrayscript  -p batch -c 6  --mem-per-cpu=65536
````

- 11 chrs were merged so far (17-Sep-2022, 23:38). All the chrs merged successfully by Monday 8:5 AM (19 September, 2022). Now index file is being created (20 September, 2022)
```bash
cat tabix.txt | tail -1 | sarrayscript -p batch -c 4 --mem-per-cpu=16384 -J indexing
```

- The final conversion of the files has to do with converting the merged file containing entire autosomes to plink format for step 1 of GWAS in REGENIE. Here is the command being run on the servers (18:30, 21-Sep-2022):
```bash
cat qcUKBB.sh | tail -1 | sarrayscript -p batch -c 12 --mem-per-cpu=65536 -J 2plink
```
- We need to separate SNP-array genotype from imouted SNPs. REGENIE does not recommand conducting step 1 on >1M  variants! We need to find a way to do so.

- We can proceed by exclusing the imputed variants and only keep 820K gentyped SNPs in UKBB. We use plink to extract these array SNPs and take them imput for step 1 prediction! (3-Oct-2022)

```bash
#making SNPs region file to extract genotyped variants from plink file
cat genotypedSNPs_without_END.txt | awk '{print $1 "\t" $2 "\t" $2}' > genotypedSNPs.txt

#extract genotyped variants from plink file
echo 'plink2 --bfile /scratch/UKBB/imputed-500k_V3/ukb_imp_allCHRs_v3_pruned_MAF05_MAC10 --extract range ~/projects/UKBB_Ryo/genotypedSNPs.txt --make-bed --out genotypedUKBB' | sarrayscript -p batch -c 4 --mem-per-cpu 17000 -J "extraction" 
```
- Extraction of the genotyped SNPs started to run on servers on 8:30 PM Wednesday 05-Oct-2022.

#### Sample file
- Creating sample file from VCF to be used for REGENIE GWAS steps:

```bash
# creating .sample file from VCF:
bcftools query -l filename.vcf.gz > UKBB.sample

# creating .sample file from plink .fam file:
echo -e "ID_1\tID_2\tmissing\n0\t0\t0" | (cat - genotypedUKBB.fam | cut -f1-3) > genotypedUKBB.sample

# Number of samples in genotype file
cat genotypedUKBB.sample | wc -l
487,411

# Number of samples in phenotype
tail -n +2 /home/rfujii/ukbb/00_data/pheno.txt | awk '{print $1,$2}' | wc -l
468,103

# Common samples in genotype and phenotype files
grep -wFf pheno.sample genotypedUKBB.sample | wc -l
462,935
```

#### Running GWAS using REGENIE
- Still trying to figure out what's wrong with the sample file!! Step 1 is pending to recieve a correct sample ids compaible with QC-ed genotyped and phenoyped data (12-Oct-2022 - 14-Oct-2022 - Fucking .sample file!!!!! 18-10-2022). 

- By changing the order of the columns and seperating the sample ids in .fam file, the step 1 of GWAS using REGENIE on the UKBB genotyped SNPs lunched successfully! Oh, finally done (lunching time: Wed 17:50, 19-10-2022; finishing time: Saturday 07:02, 22-Oct-2022).

```bash
cat out_step1.txt | sarrayscript -p batch -c 4 --mem-per-cpu=65536 -J UKBB_step1.sh
```

- Step 2 of GWAS using REGENIE on the UKBB imputed+genotyped SNPs lunched using parallelization distributing in 22 jobs running on the servers (lunching time: Monday 17:30, 24-Oct-2022; Step 2 is still ongoing after ... days for the CHR1:12 | Friday 13:16, 28-Oct-2022).

```bash
cat out_step2.txt | sarrayscript -p batch --mem-per-cpu=8192 -J UKBB_step2.sh
```

#### Controlling genomic inflation of the GWAS summary results
# QQ- and Manhattan plots
```bash
sbatch --mem=32768 --wrap './qqplot.R ~/projects/UKBB_Ryo/output/GWAS_Pheno2.regenie.gz Pheno2 ~/projects/UKBB_Ryo/output'
```

Dariush | 02.11.2022
______________________________________________________________________
______________________________________________________________________
## DNAnexus

- The UK Biobank dataset is a uniquely rich resource containing over 10 petabytes of genetic and health data from over 500,000 volunteer participants. With the launch of RStudio Workbench Trial Version on the Research Analysis Platform, approved UK Biobank researchers can now analyze this extensive dataset using their programming language of choice.

- Experts from RStudio, UK Biobank and DNAnexus walk through using RStudio Workbench to analyze the extensive UK Biobank dataset, available to all UK Biobank researchers free of charge until August 31. This webinar provides an overview on how to create notebooks, dashboards and incorporate Shiny apps all in the cloud on the Research Analysis Platform. -> https://www.youtube.com/watch?v=iy22sxlj5Ik


- If you'd like to un step 1 and step 2 in one job (but still not verified):

```bash


#Run on servers

```