# Preprocessing & First‑Level Analysis Scripts for the Flanker Task (SPM12)

This repository provides a streamlined and highly readable pipeline for preprocessing and first‑level fMRI analysis of the **Flanker task dataset** from **OpenNeuro**  
(**ds000102**: https://openneuro.org/datasets/ds000102/versions/00001) using **SPM12**.

The scripts are designed to reproduce the group‑level results demonstrated in  
**Andy’s Brain Book – SPM Overview**  
https://andysbrainbook.readthedocs.io/en/latest/SPM/SPM_Overview.html  

While following the same analytical logic, this repository adopts a distinct coding style that emphasizes **clarity, modularity, automation, and ease of reuse**.

---

## Motivation

Andy’s original scripts are comprehensive and highly educational, but new users may find them difficult to read, modify, or adapt for flexible batch processing. This pipeline addresses those limitations by providing a cleaner and more modular scripting framework while preserving methodological consistency.

---

## Key Features

- **Separated preprocessing and first‑level modeling**  
  Each stage can be executed independently, allowing users to replace preprocessing steps with alternative pipelines if desired.

- **Readable and maintainable code**  
  Scripts are modular, variables are clearly named, and extensive comments are provided to facilitate understanding and customization.

- **Reproducible analysis**  
  The pipeline closely follows the procedures described in Andy’s Brain Book, enabling replication of published group‑level results with minimal setup.

- **Batch‑friendly design**  
  The structure is easily extendable to multiple subjects, sessions, or related experimental paradigms.

---

## Software Versions

Tested with:

- **SPM12** (revision 7771)
- **MATLAB** R2023b

---

## Comparison with Andy's 2nd-level result

<img width="1085" height="805" alt="image" src="https://github.com/user-attachments/assets/2a0c7ac0-8baa-42f4-80ed-c9905cbce11a" />

- **left** : screenshot from Andy's Brainbook video: https://www.youtube.com/watch?v=lSIi-aeZO5M 
- **right** : 2ndlevel results produced by the current script
