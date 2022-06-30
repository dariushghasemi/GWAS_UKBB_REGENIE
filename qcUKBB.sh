#!/bin/bash

#genotype=~/projects/gwas/replicationAnalysis/formats_merge_conversion
genotype=/scratch/UKBB/imputed-500k_V3

#Convert BGEN to plink(bed/bim/fam) and simulatneously pruning SNPs

for chr in 21  22; #{1..22};  
	do echo "plink2  --bgen $genotype/ukb_imp_chr${chr}_v3.bgen  \
			ref-first   \
			--sample $genotype/ukb_imp_chr21_v3.sample  \
			--maf 0.05  \
			--mac 10    \
			--no-id-header \
			--make-bed  \
			--out $genotype/test/ukb_imp_chr${chr}_v3.pruned "
done

#making list of the plink files to be merged
#ls $genotype/test/ukb_imp_chr*_v3.pruned.bed | sed 's/.bed//' > $genotype/test/myfilesnames.txt

#merge plink files
#plink --merge-list $genotype/test/myfilesnames.txt --make-bed --out $genotype/test/chr21_22_Merged


#			--write-snplist \
#			--write-samples  \
