function bin_size
%% This script is meant for calculation of bin size for frequency distribution based on Freedman-Diaconis rule, binsize(h)=2×IQR×n^1/3 
%% This uses an excel file, where each column has mEPSC amplitudes from a one neuron
%% An example excel file to use this script is uploaded named as,'data for bin_size.xlsx'. 
%% Since an uniform binsize needs to be used across experiments, all the data (control and experimental) is used for this calculation
%% This script needs to be placed in the same folder as the data file, 
%% In the user prompt select or enter correct information as suggested in the promt.
%% This returns a .mat file (with the same name as the sheet in the excel file used for calculation) with mean and median values of bin size 
% ---------- User input dialogues ------- % 
prompt = {'File name_MUST START WITH A LETTER','sheet name','data coordinates to calculate binsize'};%'Figure1_name','Figure2_name'}; % prompt creates all the input prompts,to add extra input add a prompt in this list 
dlg_title = 'Enter Inputs';
num_lines=1;
defaultans={'data for bin_size.xlsx','for RS_bin size','b6:p50'}; % Default values of the inputs in the same sequence as in 'prmpt'
inputs=inputdlg(prompt,dlg_title,num_lines,defaultans);
% ----- access all the inputs given by user in proper formats ------ % 
file_name=inputs{1}; % name of the xls file
sheet=inputs{2};% name of the sheet containg data
cntrl_cntrl=inputs{3};% coordinates of the sheet containg data used for calculation
 
%% ----- get the data in usable format ------- %% 
[numeric_c,txt,raw]=xlsread(file_name,sheet,cntrl_cntrl); %% 'filename' should have full extenstion,'c9:m135' is the range of data to be copied,'numeric is copy of numerical values from xl sheet'  

% -------  calculate the bin size ------ % 
% Freedman-Diaconis rule, binsize(h)=2×IQR×n^1/3,
r=iqr(numeric_c(:,:)); % calculating interquartile range of all the columns 
binsize_all=(2*r)/(100^(1/3)); % calculating binsize based on FD rules
binsize_median=median(binsize_all,2); % median of binsizes of the population 
binsize_mean=mean(binsize_all,2); % mean of binsizes of the population 
save(sheet,'binsize_median','binsize_mean'); % Data is saved as a .mat file 



