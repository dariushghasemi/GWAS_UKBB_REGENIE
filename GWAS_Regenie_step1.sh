#!/bin/bash

Genotype=~/projects/UKBB_Ryo
Phenotype=/home/rfujii/ukbb/00_data
Output=~/projects/UKBB_Ryo/output
#Samples=/scratch/UKBB/imputed-500k_V3/ukb_imp_chr21_v3.sample
#pheno_Pheno1_Pheno2.txt
  #--lowmem \
  #--lowmem-prefix ${Output}/tmpdir/regenie_tmp_preds \
#${}

echo "regenie \
  --step 1 \
  --bgen ${Genotype}/concatedated_chr21_22_plink.pruned0.bgen \
  --sample ${Genotype}/ukbb_chr21_22_plink_pruned0.sample3 \
  --phenoFile ${Phenotype}/pheno.txt \
  --covarFile ${Phenotype}/cov.txt \
  --phenoColList Pheno1,Pheno2 \
  --bsize "1000" \
  --out ${Output}/step1_fit_UKBB_Pheno1_with_AGE_SEX_PCs "

