#!/bin/bash

genotype=/scratch/UKBB/imputed-500k_V3
bgenix=/home/ekoenig/Software/bgen_dl/gavinband-bgen-8ee23eb1cb34/build/apps/bgenix
imputation_header=/scratch/ekoenig/UKBB/WES50K/imputation.header.vcf
ref=/home/shared/bioinf/NGSpipeline/data/GRCh37-lite.fa

#Convert BGEN to VCF and simulatneously pruning SNPs
for chr in {1..22};  
	do echo "$bgenix -g $genotype/ukb_imp_chr${chr}_v3.bgen -vcf | \
	bcftools reheader -h ${imputation_header} | \
	vcftools --vcf - --maf 0.05 --mac 10 --recode --recode-INFO-all --stdout | \
	bcftools norm -Oz --check-ref -s -f ${ref} -d none -o $genotype/test/ukb_imp_chr${chr}_v3_pruned_MAF.05_MAC10.vcf.gz
	tabix -p vcf $genotype/test/ukb_imp_chr${chr}_v3_pruned_MAF.05_MAC10.vcf.gz"
done

##Convert BGEN to VCF and simulatneously pruning SNPs
#for chr in 21  22; #{1..22};  
#	do echo 
#		"plink2	--bgen $genotype/ukb_imp_chr21_v3.bgen	ref-first \
#			--sample $genotype/ukb_imp_chr21_v3.sample \
#			--maf 0.05 \
#			--mac 10 \
#			--export vcf vcf-dosage=DS  bgz \
#			--out $genotype/test/ukb_imp_chr${chr}_v3.pruned.plink.vcf.gz"
#done

#making list of the plink files to be merged
#ls $genotype/test/ukb_imp_chr*_v3.pruned.bed | sed 's/.bed//' > $genotype/test/myfilesnames.txt

#merge plink files
#plink --merge-list $genotype/test/myfilesnames.txt --make-bed --out $genotype/test/chr21_22_Merged


