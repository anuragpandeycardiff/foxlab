%% this script is meant to plots multiple cumulative frequency distribution in one figure as multiple subpanels, all the calculation are already done 
%% this is for plotting data from MD experiments(amplitude or frequency based on selection) in 8 subpanels
%% first organise data in the excel sheet-very important, an example excel file is given as, 'plots.xlsx'. 
%% It takes data from excel file named plots 030821, with different sheets containing different data
%% The mean and SEM of data are calculated previously 
%% first column always the Bincenter
%% second column and everyfourth column afterwards is control while 4th column and every 4th column afterwards is data
%% the last column has names for legend, and last row has labels for the figure panels 
%% ------------------------------------------ %%
%% ------------------------------------------ %%

prompt = {'File name_MUST START WITH A LETTER','sheet name','bin center column'} % prompt creates all the input prompts,to add extra input add a prompt in this list 
dlg_title = 'Enter Inputs-No caps';
num_lines=1;
defaultans={'plots.xlsx','DE_IEI','1'}; % Default values of the inputs in the same sequence as in 'prmpt'
% binsize has already been calculated using Freedman-Diaconis rule, 
% for IEI, enter 0.5,for amplitudes enter 1.0.
inputs=inputdlg(prompt,dlg_title,num_lines,defaultans);
% ----- access all the inputs given by user in proper formats ------ % 
file_name=inputs{1}; % name of the xls file
sheet=inputs{2};% name of the sheet containg data
bincenter=str2double(inputs{3});% column containing bin start and converting the english alphabets to numbers 
[raw_data,txt,raw]=xlsread(file_name,sheet);% takes out data from the excel file    
bin_center=raw_data(:,(bincenter)); % column containing bin start and converting the english alphabets to number 
% all plots on the same figure
txt_dim=size(txt); % number of 'rows' and 'cols' in the cell 'txt', will be used for indexing legends. 
figure(1)

    for n=1:6
        subplot(2,3,n)
        errorbar(bin_center(:),raw_data(:,n+3*(n-1)+1),raw_data(:,n+3*(n-1)+2),'-o','MarkerSize',8,'LineWidth',2,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD','Color','#0072BD');% control
        hold on 
        errorbar(bin_center(:),raw_data(:,n+3*(n-1)+3),raw_data(:,n+3*(n-1)+4),'-s','MarkerSize',8,'LineWidth',2,'MarkerFaceColor',	'#77AC30','MarkerEdgeColor','#77AC30','Color','#77AC30');% experimental
        xlim([0,10]); ylim([0.0,1]);        
        xlabel('Interevent interval(sec)'); ylabel('Cumulative frequency') % adding extra line between two rows of subplots
        set(gca,'FontSize',22, 'FontWeight','normal','LineWidth',2.0);
        grid off; box off %set(gcf,'color','k'); 
        text(0,1.15,txt{36,n+1},'FontSize',23,'FontWeight','bold'); % inserting the subpanel labels, take the strings from the first row of the sheet
        title(" ",txt{1,n*4},'FontSize',20,'FontWeight','bold'); % take the strings from the cell named 'txt'. 'txt' is originated from the first rows('titles') of the columns in the excel sheet 
        legend(txt{n*4,txt_dim(2)},txt{(n*4)+2,txt_dim(2)},'FontSize',19,'FontWeight','normal','Location','southeast');
        legend('boxoff');     
    end 

% the marker colours can be changed by selecting following colours
%('MarkerFaceColor','#A2142F','MarkerEdgeColor','#A2142F','Color','#A2142F') for amps control 
%('MarkerFaceColor','#7E2F8E','MarkerEdgeColor','#7E2F8E','Color','#7E2F8E') for amps MD
% edit the figure titles
saveas(figure(1),sheet); % save the figure with the samne names as the sheet's name in original excel datafile.
    





