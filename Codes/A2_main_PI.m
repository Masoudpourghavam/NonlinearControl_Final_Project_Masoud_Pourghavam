% Final Project
% Masoud Pourghavam
% Student Number: 810601044
% University of Tehran

%% --------------------------------------------- %%
clc;
clear all;
close all;

%% --------------------------------------------- %%

real_time = 'n';
plot_on = 'n';
eq_intensity = .4;           % EQ Intensity 
                             %   1: El centro, 2: Kobe, 3: Morgan,  4: Chirp input
f_ini = 0;                   % Chirp initial freq. [Hz] 
f_end = 10;                  % Chirp end freq. [Hz]

fs = 4096;              % Sampling frequency [Hz]
dt_rths = 1/fs;         % Sampling period [sec]
load_system('vRTHS_MDOF_SimRT_PI.slx')           
switch lower(real_time)
    case 'y'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','off')      
    case 'n'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','on')
end

num_add = 0;
num_t = 1+num_add;
E_swN=1; Building_cN=1; %E_swN=4; Building_cN=4;
J=cell(1,E_swN);
caseN=E_swN*Building_cN*num_t;
disp([num2str(caseN),' cases totally.'])
disp('Processing ...')
for E_sw=1:E_swN
    J{E_sw}=zeros(num_t,9,Building_cN);
    for Building_c=1:Building_cN
        for ii = 1:num_t
            F1_input_file
            F2_controller_PI
            F3_simulation_PI
            F4_evaluation_PI
            J{E_sw}(ii,:,Building_c)=eval_crit;
            casei=((E_sw-1)*Building_cN+Building_c-1)*num_t+ii;
            caseratio=casei/caseN*100;
            disp(['Case ',num2str(casei),' is done (',num2str(caseratio),'%).'])
        end
    end
end
