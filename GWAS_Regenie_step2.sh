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
#  --covarExcludeList UACR \

for chr in $(seq 1 22); 
do 
echo "regenie   \
	--step 2 \
	--bgen ${Genotype}/ukb_imp_chr${chr}_v3.bgen \
	--sample ${home}/genotypedUKBB.sample \
	--phenoFile ${Phenotype}/pheno.txt \
	--covarFile ${Phenotype}/cov.txt \
	--phenoColList Pheno1,Pheno2 \
	--covarColList SEX,AGE,PC{1:40} \
	--pred ${Output}/step1_fit_UKBB_AllChrs_with_AGE_SEX_PCs_pred.list \
	--minMAC 100 \
	--bsize 1000 \
	--out ${Output}/step2_UKBB_with_AGE_SEX_PCs_chr${chr} \
	--gz "
done

#cat out_step2.txt | sarrayscript -p batch --mem-per-cpu=8192 -J UKBB_step2.sh