function cumhistogram
%% This script is meant to calculate the cumulative frequency distribution (cfds) of mEPSC amps or frequencies.
%% AN example excel file to be used with this script is given as, 'example data_cumhistogram.xlsx'. 
%% These files have two sets of data, one fro control(or experiment 1) and other for experiment (experiment 2).
%% select rows and columns of these experiments. 
%% it calculates cdfs for each column of data from a given sheet of a given excel file.
%% Each column of the data represents measurements of all the the mEPSC amps or interevent interval.
%% In the pop up select right file, sheet namd and range and intereven interval of the data used to calculate the cdfs.
%% This script should be placed in the same folder as excel file, as the election to data path is not included here.
%% the output of this script is a matlab file(.mat), eg. bin size, cdfs, mean and SEMs of cdfs from all the cells in a given experiment, this will be used to prepare final plots.
%% The above .mat file has the name same as the sheet's name used for the calculation.
%% This also give a figure file shgowing CDF plots of two groups of data. 
%% Take the mean and SEM values from this output .mat file and copy to another excel file to prepare the final plots. 

prompt = {'File name_MUST START WITH A LETTER','sheet name','control data coordinates','deprived data coordinates  from excel sheet','bin size'};%'Figure1_name','Figure2_name'}; % prompt creates all the input prompts,to add extra input add a prompt in this list 
dlg_title = 'Enter Inputs';
num_lines=1;
defaultans={'example data_cumhistogram.xlsx','RS_IEIs','b6:p50','r6:z50','0.5'}; % Default values of the inputs in the same sequence as in 'prmpt'
% binsize has already been calculated using Freedman-Diaconis rule, for
% IEI, select 0.5 while for amps it is 1.0. 
inputs=inputdlg(prompt,dlg_title,num_lines,defaultans);
% ----- access all the inputs given by user in proper formats ------ % 
file_name=inputs{1}; % name of the xls file
sheet=inputs{2};% name of the sheet containg data
cntrl_cntrl=inputs{3};% coordinates of the sheet containg experimental data, in the graph it's data1
cntrl_exp=inputs{4};% coordinates of xls sheet containing control data, in the graph it's data2 
binsize_str=inputs{5};binsize=str2double(binsize_str); % binsize 
  
%% ----- get the data in usable format ------- %% 
[numeric_c,txt,raw]=xlsread(file_name,sheet,cntrl_cntrl); %% 'filename' should have full extenstion,'txt' is the range of data to be copied,'numeric is copy of numerical values from xl sheet'  
[numeric_ex,txt,raw]=xlsread(file_name,sheet,cntrl_exp); %% 'filename' should have full extenstion,'txt' is the range of data to be copied,  

%%---------plot Young OR control data set -------------------------------- %%

[rw_c,cl_c]=size(numeric_c); % rw==row, cl==column in 'numeric'
% bin size has been determined by freedman-diaconis rule. for details look
% at Analysis notes binsize=(2*IQR)/(n^1/3)--IQR is interquartile range 
bin_lim=max(max([numeric_c,numeric_ex])); % largest value to determine the range for bins 
bin_lim=round(bin_lim)+1; %
bins=[0:binsize:bin_lim]; % bin limits, same for control and experimental 
% figure(1);
% --- this plots only histograms not cdfs, just for reference, can be ignored --- % 
% creates an array with counts in each bin for each column of the data array in the matrix 'bncnt_cntrl'
for n=1:cl_c
    y=histogram(numeric_c(:,n),bins); %% returns y=histogram of numeric with x bins
    bncnt_cntrl(:,n)=y.BinCounts; bnedgs_cntrl(:,n)=y.BinEdges; 
    figure(1)
    histogram(numeric_c(:,n),bins);
end
% now find mean and SEM of each bin in the matrix 'bncnt_cntrl'
%%% do it with time %%
% ------------------------------------------------------- % 
% ------Now plot cumulative distribution --------------- % 
% figure(2);
for n=1:cl_c
    dd=numeric_c(:,n); dd(isnan(dd))=[]; % copies column(n) to dd and removes NaN from this
    binvalues_c_no(:,n)=histc(numeric_c(:,n),bins);
    binvalues_cumulative_c_no(:,n)=cumsum(histc(numeric_c(:,n),bins));
    binvalues_c(:,n)=(cumsum(histc(numeric_c(:,n),bins)))/size(dd,1); % this fills the vectors 'binvalues' cumulative number of points in each bin and converts cumulative number to cumulative frequency
    % convert cumulative number to cumulative frequency 
    plot(bins,binvalues_c,'*');
    hold on
end
median_c=(median((numeric_c),'omitnan'))'; % median of all columns individually and get the data in a single column
quartile_c1=(quantile(numeric_c,0.25))'; %Calculating first and  fourth quartiles
quartile_c3=(quantile(numeric_c,0.75))'; % fourth quartile

binvalues_c_mean=mean(binvalues_c,2);% mean of all the columns of cum freq distribution
sd=std(binvalues_c');sd=sd'; sem_c=sd/sqrt(cl_c); % sd-standard deviation of binvalues,sem=SEM of binvalues
errorbar(binvalues_c_mean,sem_c,'*','LineWidth', 2);
clear dd numeric;
%% ---------------------------------- %% 

%% ----- NOW PLOT FOR old control DATA SET ---------------%%  

[rw_ex,cl_ex]=size(numeric_ex); % rw==row, cl==column in 'numeric'

% figure(1);
% --- this plots only histograms not cdfs --- % 
for n=1:cl_ex
    y=histogram(numeric_ex(:,n),bins); %% returns y=histogram of numeric with bins edges taken from vector 'bin'
    bncnt_ex(:,n)=y.BinCounts; bnedgs_ex(:,n)=y.BinEdges;% s=(sum(y')');(s=s/cl);%% s=average no of elements in each bin(averaged across no of columns in numeric) 
end
% ---------------------- % 

% figure(2);
for n=1:cl_ex
    dd=numeric_ex(:,n); dd(isnan(dd))=[]; % copies column(n) to dd and removes NaN from this
    binvalues_ex_no(:,n)=histc(numeric_ex(:,n),bins);
    binvalues_cumulative_ex_no(:,n)=cumsum(histc(numeric_ex(:,n),bins));
    binvalues_ex(:,n)=(cumsum(histc(numeric_ex(:,n),bins)))/size(dd,1); % this fills the vectors 'binvalues' cumulative number of points in each bin
    % convert cumulative number to cumulative frequency 
    plot(bins,binvalues_ex,'*');
    hold on
end
median_ex=(median((numeric_ex),'omitnan'))';% median of all columns individually and get the data in a single column
quartile_ex1=(quantile(numeric_ex,0.25))'; %Calculating first and  fourth quartiles
quartile_ex3=(quantile(numeric_ex,0.75))';

%% ------------------------------------------------------------%%
binvalues_mean_ex=mean(binvalues_ex,2);% mean of all the columns of cum freq distribution
sd_ex=std(binvalues_ex');sd_ex=sd_ex'; sem_ex=sd_ex/sqrt(cl_ex); % sd-standard deviation of binvalues,sem=SEM of binvalues
%figure(x); % plots the mean+SEM of control and experimental 
figure(2)
errorbar(bins',binvalues_c_mean,sem_c,'-ko','LineWidth', 2);
hold on 
errorbar(bins',binvalues_mean_ex,sem_ex,'-bo','LineWidth', 2); xlim([0 15]);
xlabel('Bin start (sec)');ylabel('Cumulative frequency');
legend('Control',sheet); % takes the name of the sheet as legend for experimental data
saveas(figure(2),sheet);

% to do KS test between 2 conditions, all the datapoints in one condition should be in one column of one variable
cntrl_test=numeric_c(:); % data from all cells in one column 
cntrl_exp=numeric_ex(:);

[h,P,KSSTAT]=kstest2(cntrl_test, cntrl_exp); % does KS test for difference in distribution b/w control and experimental
pp=num2str(P);h_value=num2str(h);
% --- now compare medians of the two groups of data --- % 
 % get the two medians in one matrix
[p_median,h_median]=ranksum(median_c,median_ex); % does wilcoson rank sum test between medians of control and experiment data 
[p_q1,h_q1]=ranksum(quartile_c1,quartile_ex1); % do willcoxon test with 1st and 3rd quartiles
[p_q3,h_q3]=ranksum(quartile_c3,quartile_ex3);
% ------ save all the analysis parameters ----- % 
parameters=strcat('File name = ',file_name,',',' Experiment name = ',sheet,',',' P value= ',pp,',',' bin size=',' ',binsize_str,' h value= ', '=' ,h_value);%,'binvalues_c_mean',' ',Mean_c,' ','sem_c',SEM_c,'binvalues_mean_ex',' ',mean_ex,' ','sem_ex',SEM_ex); % create a string containing all the parameters used 

% ---- manually perform KS test ---- %

obs=length(numeric_c);obsrt=obs^0.5;
D_KS=[1.63/obsrt 1.36/obsrt 1.22/obsrt]; % K-S test P-vales for Alpha=0.01, 0.05 and 0.1 respectively. for events>50 these values depend on no. of events. 

d=max(abs(binvalues_c_mean-binvalues_mean_ex)); % d is differece bw cdfs of two populations at the point of max diff
% null hypothesis is that numeric_c and numeric_ex have same distribution
% if D_KS-d is positive null hypothesis is rejected at corresponding P value in D_KS
KS_stats=vertcat([0.01 0.05 0.1],D_KS,(D_KS-d));% first column is KS test P-value corresponding to P<0.01, P<0.05 & P<0.1 respectively   
% -- add the bin centers as the first column in binvalues_c and binvalues_ex  
binvalues_c=[transpose(bins) binvalues_c]; % merging two matrices
binvalues_ex=[transpose(bins) binvalues_ex];
binvalues_c_no=[transpose(bins) binvalues_c_no];
binvalues_ex_no=[transpose(bins) binvalues_ex_no];

filename=sheet; % save all the measurements in a matlab file(.mat), eg. bin size, cdfs, mean and SEMs of cdfs from all the cells in a given experiment, this will be used to prepare final plots
save(filename,'file_name','sheet','binsize','binvalues_c','binvalues_ex','bncnt_cntrl','bncnt_ex','bnedgs_cntrl','bnedgs_ex','binvalues_cumulative_c_no','binvalues_cumulative_ex_no','binvalues_c_no','binvalues_ex_no','P','KSSTAT','parameters','h','binvalues_c_mean','sem_c','binvalues_mean_ex','sem_ex','p_median','h_median','median_c','median_ex','p_q1','h_q1','p_q3','h_q3','KS_stats');
end 