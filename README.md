# GWAS_UKBB_REGENIE
Running GWAS on Kidney's latent phenotypes via REGENIE v1.0.6.7.

- In qcUKBB.sh you'll find the commands for format conversion of UKBB genotype file (BGEN) using plink.

- Fo Step 1 of GWAS via REGENIE, we need a merged file contating all the genotypes from autosomes (chromosome 1 to 22) in one single file in BGEN or plink{.bed/.bam/.fam) formats. 

- To prepare such file, we are using plink to to convert the BGEN files to plink and meanwhile impose our criteria for filtering SNPs based on their Minor Allele Frequency (MAF) and Allel Count (AC).

- Before merging the converted plink files, we need to store their names in text file, here called "myfilesnames.txt".

- Then, we use plink2 to merged the QC-ed plink files. This merged file consisting all the the autosomes genotypes is going to be used for step1 of GWAS using REGENIE where we need to find the most important SNPs across all SNPs of the study to make a prediction file for Step 2 og GWAS.

- File format conversion using plink2 was unsucessful! Plink couldn't merge multiallelic SNPs positions using plink input. 

- I now go on the alternative approach which utilizes bgenix tool to convert the genotype files from BGEN to VCF file. One can also plink2 to condeuct this conversion if they don't have bgenix installed on their Unix machine. (As in parallel I tested BGEN->VCF format conversion via Plink2 and it worked too.)

- I also directly piped the converted file in VCF format to vcftools for pruning SNPs by MAF/MAC, and then to bcftools for reheadering file. So, they all worked well.