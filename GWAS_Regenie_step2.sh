#!/bin/bash

Genotype=/scratch/UKBB/imputed-500k_V3
Phenotype=/home/rfujii/ukbb/00_data
Output=~/projects/UKBB_Ryo/output
home=~/projects/UKBB_Ryo

#bsize=1000 "${bsize}"
#aaf-bins1=0.1
#aaf-bins2=0.5
#  --aaf-bins ${aaf-bins1}, ${aaf-bins2} \
#  --covarCol PC{1:10} \
#	--covarExcludeList UACR \

#for chr in $(seq 21 22); 
#do 
echo "regenie   \
	--step 2 \
	--bgen ${home}/concatedated_chr21_22_plink.pruned0.bgen \
	--sample ${home}/ukbb_chr21_22_plink_pruned0.sample3 \
	--phenoFile ${Phenotype}/pheno.txt \
	--covarFile ${Phenotype}/cov.txt \
	--phenoColList Pheno1,Pheno2 \
	--covarColList SEX,AGE,PC{1:40} \
	--pred ${Output}/step1_fit_UKBB_Pheno1_with_AGE_SEX_PCs_pred.list \
	--minMAC 100 \
	--bsize 1000 \
	--out ${Output}/step2_UKBB_Pheno1_with_AGE_SEX_PCs_firth \
	--gz "
#done

#cat out_step2.txt | sarrayscript -p slow --mem-per-cpu=65536 -J UKBB_step2.sh