%-----------------------------------------------------------------------
% spm_preprocessing_flankertask
% Script originally created by Andrew Jahn, University of Michigan, 10 January 2020 
% (https://github.com/andrewjahn/SPM_Scripts/blob/master/RunPreproc_1stLevel_job.m)
%
% This script is intended for preprocessing the Flanker dataset:
% https://openneuro.org/datasets/ds000102/versions/00001
%
% It is used as part of the Scripting chapter in the SPM walkthrough:
% https://andysbrainbook.readthedocs.io/en/latest/SPM/SPM_Short_Course/SPM_06_Scripting.html
%
% This version has been edited by Zou Zirui, 26/09/2025, to enhance readability and facilitate usage by requiring only a few directory settings.
%
% Note: This script performs only the preprocessing step. For first-level modeling, please use the 'Flanker_FirstLv.m' script. Preprocessing and first-level analysis are separated to allow flexibility: you may preprocess data using other software and still use the SPM first-level script for statistical modeling. SPM does not need to be used for the entire pipeline.
%-----------------------------------------------------------------------

%% BASIC SETTINGS
% by setting the following simple parameters and directories, the script can run easily
subjects = [01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26]; % Replace with a list of all of the subjects you wish to analyze
user = getenv('USER'); % Will return the username for OSX operating systems; change to 'USERNAME' for Windows
% input the directory of spm and the flanker data
% e.g., spmDir = '/Users/zirui.zou/matlab_toolbox/spm12/';
% baseDir = '/Users/zirui.zou/Flanker/'
spmDir = '';
baseDir = '';
% Zero-pads each number so that the subject ID is 2 characters long
for subject=subjects
subject = num2str(subject, '%02d'); 
%%

%% UNZIP THE DATA FILES DOWNLOADED FROM OPENUERO
% Check whether the files have been unzipped. If not, unzip them using
if isfile([baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-1_bold.nii']) == 0
    display('Run 1 has not been unzipped; unzipping now')
    gunzip([baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-1_bold.nii.gz'])
else
    display('Run 1 is already unzipped; doing nothing')
end

if isfile([baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-2_bold.nii']) == 0
    display('Run 2 has not been unzipped; unzipping now')
    gunzip([baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-2_bold.nii.gz'])
else
    display('Run 2 is already unzipped; doing nothing')
end

if isfile([baseDir 'sub-' subject '/anat/sub-' subject '_T1w.nii']) == 0
    display('Anatomical image has not been unzipped; unzipping now')
    gunzip([baseDir 'sub-' subject '/anat/sub-' subject '_T1w.nii.gz'])
else
    display('Anatomical image is already unzipped; doing nothing')
end

%% PREPROCESSING BEGINS
% Execute the code specified in the SPM GUI
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'run1run2Files';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                     {[baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-1_bold.nii']}
                                                                     {[baseDir 'sub-' subject '/func/sub-' subject '_task-flanker_run-2_bold.nii']}
                                                                     }';
% 1. realignment
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Named File Selector: run1run2Files(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.spm.spatial.realign.estwrite.data{2}(1) = cfg_dep('Named File Selector: run1run2Files(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
% 2. slice-timing correction
matlabbatch{3}.spm.temporal.st.scans{1}(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{3}.spm.temporal.st.scans{2}(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','rfiles'));
matlabbatch{3}.spm.temporal.st.nslices = 40;
matlabbatch{3}.spm.temporal.st.tr = 2;
matlabbatch{3}.spm.temporal.st.ta = 1.95;
matlabbatch{3}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
matlabbatch{3}.spm.temporal.st.refslice = 1;
matlabbatch{3}.spm.temporal.st.prefix = 'a';
% 3. coregistation
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{4}.spm.spatial.coreg.estwrite.source = {[baseDir 'sub-' subject '/anat/sub-' subject '_T1w.nii,1']};
matlabbatch{4}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
% 4. segmentation 
matlabbatch{5}.spm.spatial.preproc.channel.vols = {[baseDir 'sub-' subject '/anat/rsub-' subject '_T1w.nii,1']};
matlabbatch{5}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{5}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{5}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{5}.spm.spatial.preproc.tissue(1).tpm = {[spmDir 'tpm/TPM.nii,1']};
matlabbatch{5}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{5}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{5}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(2).tpm = {[spmDir 'tpm/TPM.nii,2']};
matlabbatch{5}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{5}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{5}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(3).tpm = {[spmDir 'tpm/TPM.nii,3']};
matlabbatch{5}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{5}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{5}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(4).tpm = {[spmDir 'tpm/TPM.nii,4']};
matlabbatch{5}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{5}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{5}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(5).tpm = {[spmDir 'tpm/TPM.nii,5']};
matlabbatch{5}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{5}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{5}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(6).tpm = {[spmDir 'tpm/TPM.nii,6']};
matlabbatch{5}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{5}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{5}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{5}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{5}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{5}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{5}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{5}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{5}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{5}.spm.spatial.preproc.warp.write = [0 1];
% 5. normalization
matlabbatch{6}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
matlabbatch{6}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{6}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
matlabbatch{6}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{6}.spm.spatial.normalise.write.woptions.prefix = 'w'; 
% 6. smoothing
matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{7}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{7}.spm.spatial.smooth.dtype = 0;
matlabbatch{7}.spm.spatial.smooth.im = 0;
matlabbatch{7}.spm.spatial.smooth.prefix = 's';
% the final preprocessed image will be files with 'swar' prefix 
%% LAUNCH THE BATCH SCRIPT
spm_jobman('run', matlabbatch);
end