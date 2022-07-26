#!/bin/bash

#genotype=~/projects/gwas/replicationAnalysis/formats_merge_conversion
genotype=/scratch/UKBB/imputed-500k_V3

#Merging the converted BGEN->VCF files

for chr in $(seq 21 22);
	do echo "/scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr${chr}_v3.pruned.vcf.gz" >> myVCFnames.txt
done

bcftools concat --naive -f myVCFnames.txt --output-type v -o /scratch/UKBB/imputed-500k_V3/test/concatedated_chr21_22_plink.pruned.vcf.gz
bcftools concat -Oz  /scratch/UKBB/imputed-500k_V3/test/converted/ukb_imp_chr21_v3.pruned0.vcf.gz   \
		     /scratch/UKBB/imputed-500k_V3/test/converted/ukb_imp_chr22_v3.pruned0.vcf.gz   \
		     -o concatedated_chr21_22_plink.pruned0.vcf.gz > outVCFmerge.txt

cat outVCFmerge.txt | sarrayscript -c 8 -p batch --mem-per-cpu=16384 -J VCFmerge.sh

#making list of the plink files to be merged
#ls $genotype/test/ukb_imp_chr*_v3.pruned.bed | sed 's/.bed//' > $genotype/test/myfilesnames.txt
#ls /scratch/UKBB/imputed-500k_V3/test/ukb_imp_chr*_v3.pruned.vcf.gz | sort -V

#merge plink files
#plink --merge-list $genotype/test/myfilesnames.txt --make-bed --out $genotype/test/chr21_22_Merged


#			--write-snplist \
#			--write-samples  \
