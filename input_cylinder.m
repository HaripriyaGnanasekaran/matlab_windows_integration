% Input generator for flat geometery and varying a specific parameter
% developed by Ram

% ==================================================================
% Recent edits log
% ------------------------------------------------------------------
% Name	|	Description				| Date
% ------------------------------------------------------------------
% Ram	| creates input for flat geometry only.		|06,Nov,2016
% Ram	| Varies surfactant chain length from 16 - 20, 
%	  and number of layers increased to 300. 	|14,Nov,2016
%===================================================================


close all;
clc;



initial_value = 16;	% Initial value of the variable to be changed 
step = 1; 		% steps in which inital value is to be changed
end_value = 20;		% End value of the variable to be changed 
disp('Computing number of files to be created');
n = ((end_value-initial_value)/step + 1);
disp('Creating an array of variable values');

variable(n)=0;
for i = 1:n
     variable(i) = initial_value + step*(i-1);
end



for j = 1:n
    fprintf('Creating input file %d\n',j);

    % Several input files with name input_(index).dat will be created 
    filename = sprintf('input_cylinder_%d.dat',j);
    file = fopen(filename,'w');

    % Generating Grid
    % grid parameters
    gridname = 'cyl';
    n_layers = 100;
    geometry = 'cylindrical';
    lambda = 1/3;
    gradients = 1;
    upper_boundary = 'mirror1';
    lower_boundary = 'mirror1';  
    % format for inputs
    formatSpec_layers = 'lat : %s : n_layers : %d\r\n';
    formatSpec_lambda = 'lat : %s : lambda : %.16f\r\n';
    formatSpec_geometry = 'lat : %s : geometry : %s\r\n';
    formatSpec_gradients = 'lat : %s : gradients : %d\r\n';
    formatSpec_up_bound = 'lat : %s : upperbound : %s\r\n';
    formatSpec_lo_bound = 'lat : %s : lowerbound : %s\r\n';
    % file writing
    fprintf(file,formatSpec_layers, gridname, n_layers);
    fprintf(file,formatSpec_lambda, gridname, lambda);
    fprintf(file,formatSpec_geometry, gridname, geometry);
    fprintf(file,formatSpec_gradients, gridname, gradients);
    fprintf(file,formatSpec_lo_bound, gridname, lower_boundary);
    fprintf(file,formatSpec_up_bound, gridname, upper_boundary);
    fprintf(file,'\r\n');


    % Creating Monomers
    % Creating required number of monomers 

    % 1st monomer parameters
    mon_name = 'A';
    freedom = 'pinned';
    pinned_rangefrom = 1;
    pinned_rangeto = 60;
    int_with = 'B';
    chival = 0.6;
    % writing in file
    formatSpec_freedom = 'mon : %s : freedom : %s\r\n';
    fprintf(file, formatSpec_freedom, mon_name, freedom);
    formatSpec_pin_range = 'mon : %s : pinned_range : %d;%d\r\n';
    fprintf(file, formatSpec_pin_range, mon_name, pinned_rangefrom,...
        pinned_rangeto);
    formatSpec_freedom = 'mon : %s : chi - %s : %.16f\r\n';
    fprintf(file, formatSpec_freedom, mon_name, int_with, chival);    
    % 2nd monomer parameters
    mon_name = 'B';
    freedom = 'free';
    % writing in file
    formatSpec_freedom = 'mon : %s : freedom : %s\r\n';
    fprintf(file, formatSpec_freedom, mon_name, freedom);  
    fprintf(file,'\r\n');


    % Creating Molecules from monomers
    % Creating 1st Molecule
        mol_name1 = 'A'; 
        composition = 4;
        freedom = 'restricted';
        theta = 10542;
        %writing in file
        formatSpec_comp = 'mol : %s : composition : (%s)%d\r\n';
        formatSpec_freedom = 'mol : %s : freedom : %s\r\n';
        formatSpec_th = 'mol : %s : theta : %d\r\n';
        fprintf(file, formatSpec_comp, mol_name1, mol_name1, composition);
        fprintf(file, formatSpec_freedom, mol_name1, freedom);
        fprintf(file, formatSpec_th, mol_name1, theta);
    % Creating 2nd Molecule
        mol_name2 = 'B'; 
        composition = 4;
        freedom = 'solvent';
        %writing in file
        fprintf(file, formatSpec_comp, mol_name2, mol_name2, composition);
        fprintf(file, formatSpec_freedom, mol_name2, freedom);
        
    % Creating Polymer Molecule
        surf_name = 'pol'; 
        compos1 = variable(j);
        compos2 = variable(j);
        freedom = 'restricted';
        theta = 675;
        %writing in file
        formatSpec_comp = 'mol : %s : composition : (%s)%d(%s)%d\r\n';
        formatSpec_freedom = 'mol : %s : freedom : %s\r\n';
        formatSpec_th = 'mol : %s : theta : %d\r\n';
        fprintf(file, formatSpec_comp, surf_name, mol_name1, compos1, ...
            mol_name2, compos2);
        fprintf(file, formatSpec_freedom, surf_name, freedom);
        fprintf(file, formatSpec_th, surf_name, theta);

    fprintf(file,'\r\n');
    fprintf(file,'start\r\n');
    fprintf(file,'mon : A : freedom : free\r\n');
    fprintf(file,'\r\n');
    
    fprintf(file,'sys : cylinder : extra_output : interfacial_width \r\n');
    fprintf(file,'sys : cylinder : Gibbs_molecule : B \r\n');
    fprintf(file,'\r\n');

    % writing the iteration techniques to file
    fprintf(file, 'newton : isaac : method : pseudohessian\r\n');
    fprintf(file, 'newton : isaac : tolerance : 1e-10\r\n');
    fprintf(file, 'newton : isaac : e_info : false\r\n');
    fprintf(file, 'newton : isaac : s_info : true\r\n');
    fprintf(file,'\r\n');
    % writing output formats to file
    fprintf(file, 'output : filename.pro : type : profiles\r\n');
    fprintf(file, 'output : filename.pro : template : temp.pro\r\n');
    fprintf(file, 'output : filename.pro : write_bounds : false\r\n');
    fprintf(file, 'output : filename.kal : type : kal\r\n');
    fprintf(file, 'output : filename.kal : template : temp.kal\r\n');
    fprintf(file,'\r\n');
    

end
disp('Succesfully created all input files');
disp('Hurrrrayyy! You can Start running the inputs. :) ')






