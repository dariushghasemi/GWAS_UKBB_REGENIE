#!/bin/bash

Genotype=~/projects/UKBB_Ryo
Phenotype=/home/rfujii/ukbb/00_data
Output=~/projects/UKBB_Ryo/output
#Genotype=/scratch/UKBB/imputed-500k_V3
#Samples=/scratch/UKBB/imputed-500k_V3/ukb_imp_chr21_v3.sample
#--keep ${Genotype}/remained.sample \

echo "regenie \
  --step 1 \
  --bed ${Genotype}/genotypedUKBB \
  --sample ${Genotype}/genotypedUKBB.sample  \
  --phenoFile ${Phenotype}/pheno.txt \
  --covarFile ${Phenotype}/cov.txt \
  --phenoColList Pheno1,Pheno2 \
  --bsize "1000" \
  --force-step1 \
  --lowmem \
  --lowmem-prefix ${Output}/tmpdir/regenie_tmp_preds \
  --out ${Output}/step1_fit_UKBB_AllChrs_with_AGE_SEX_PCs "

