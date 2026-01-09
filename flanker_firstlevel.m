%-----------------------------------------------------------------------
% spm_firstlevel_flankertask
%
% This script performs first-level modeling for the Flanker dataset:
% https://openneuro.org/datasets/ds000102/versions/00001
%
% The script enables you to reproduce group-level results similar to those in
% Andy’s Brain Book (see: https://andysbrainbook.readthedocs.io/en/latest/SPM/SPM_Short_Course/SPM_08_GroupAnalysis.html), but follows a different code organization.
%
% Note: This script includes only the first-level analysis step. For preprocessing, please run 'Flanker_Preproc.m' first. Preprocessing and first-level analysis are separated for flexibility: you may use preprocessed images from other software (e.g., FSL) and still conduct statistical modeling using this SPM script.
%-----------------------------------------------------------------------
%% basic setting
% After running the Flanker_Preproc.m script, give the location of flanker data to baseDir. By setting this directory, the script should run smoothly. 
% e.g., baseDir = '/Users/zirui.zou/Flanker/';
baseDir = '';
% 'swar' for spm preprocessed data
SPM_prefix = 'swar';
subjects = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26'}; 
run_1 = 'run-1';
run_2 = 'run-2'; % the data has two repeated sessions
%% make directory for 1st level processing
for i = 1:length(subjects)  
    fullPath = fullfile(baseDir, '1st_level', ['sub-' subjects{i}]);  
    if ~exist(fullPath, 'dir') 
        mkdir(fullPath)  
    end
end
%% set a loop
for i = 1:numel(subjects)
    ID = subjects{i};
    firstlevelDir = fullfile(baseDir, '1st_level', ['sub-', ID]);
    % matlabbatch initialization for each loop
    matlabbatch = {}; 

    % set matlabbatch {1} 
    % spm model specification
    % read .tsv files of each session
    tsv01 = [baseDir 'sub-' ID '/func/sub-' ID '_task-flanker_' run_1 '_events.tsv'];
    tsv02 = [baseDir 'sub-' ID '/func/sub-' ID '_task-flanker_' run_2 '_events.tsv'];
    % read .txt files of multiple regressors (head movement) of each sessions (not used in this analysis)
    % rp01 = [baseDir 'sub-' ID '/func/rp_sub-' ID '_task-flanker_' run_1 '_bold.txt'];
    % rp02 = [baseDir 'sub-' ID '/func/rp_sub-' ID '_task-flanker_' run_2 '_bold.txt'];
    % set first level directory, time units, TR, etc.
    matlabbatch{1}.spm.stats.fmri_spec.dir = {firstlevelDir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.0;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set scan number manually numScans= number of scan's volumes (run-01)
    numScans = 146; 
    scans = cell(numScans, 1);
    for j = 1:numScans
        scans{j} = sprintf('%ssub-%s/func/%ssub-%s_task-flanker_%s_bold.nii,%d', baseDir, ID, SPM_prefix, ID, run_1, j);
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = scans;
    % extract onsets of session 1 (consonant)
    onsets_run1 = tdfread(tsv01);
    % extract session 1 condition 1
    incon_idx1 = ismember(onsets_run1.cond, {'cond003','cond004'});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'incongruent';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets_run1.onset(incon_idx1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 2.0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    % extract session 1 condition 2
    con_idx1 = ismember(onsets_run1.cond, {'cond001','cond002'});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'congruent';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets_run1.onset(con_idx1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 2.0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    % condition setting ends
    % other parameters
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    % import mutiple regressor parameters (like rp01, rp02, etc.)
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set scan number manually numScans= number of scan's volumes (run-02)
    numScans = 146; 
    scans = cell(numScans, 1);
    for j = 1:numScans
        scans{j} = sprintf('%ssub-%s/func/%ssub-%s_task-flanker_%s_bold.nii,%d', baseDir, ID, SPM_prefix, ID, run_2, j);
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = scans;
    % extract onsets of session 1 (consonant)
    onsets_run2 = tdfread(tsv02);
    % extract session 1 condition 1
    incon_idx2 = ismember(onsets_run2.cond, {'cond003','cond004'});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'incongruent';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = onsets_run2.onset(incon_idx2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 2.0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    % extract session 1 condition 2
    con_idx2 = ismember(onsets_run2.cond, {'cond001','cond002'});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'congruent';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = onsets_run2.onset(con_idx2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 2.0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    % condition setting ends
    % other parameters
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    % import mutiple regressor parameters 
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {''};
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % finish setting conditions
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    % spm model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% contrast manager %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % contrast 1 
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Inc-Con';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
    % contrast 2
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Con-Inc';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
    % contrast 3
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Inc';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
    % contrast 4
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Con';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% contrast manager %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % run the matlabbatch
    matlabbatch{3}.spm.stats.con.delete = 0;
    spm_jobman('run', matlabbatch)
end