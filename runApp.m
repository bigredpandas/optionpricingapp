
%Main function in order to start the app
%Matlab Version R2019b is required

clc
clear            

try

OptionPricingApp;

catch exception
    
disp('Error');
disp(exception);
    
end