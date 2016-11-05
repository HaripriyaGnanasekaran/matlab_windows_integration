

% Input file creation for SF_box
clear all;
close all;
clc;

% Reading the user created file name
filename = input('Enter the name of the input file : ','s');
file = fopen(filename,'w');

% Generating Grid
disp('**********************')
disp('NOW GENERATING LATTICE')
disp('**********************')

% grid parameters
gridname = input('Enter the grid name (String):','s');
n_layers = input('Enter the number of layers (integer): ');
geometry = input('Enter the geometry (flat, cylidrical, spherical) :','s');
lambda = input('Enter the value of lambda (real): ');
gradients = input('Enter the gradients (integer):');
upper_boundary = input('Upper boundary (choose from mirror,wall etc) :','s');
lower_boundary = input('Lower boundary (choose from mirror,wall etc) :','s'); 

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

disp('**********************')
disp('NOW GENERATING MONOMER')
disp('**********************')

num_of_mon = input('Enter the number of monomers required (integer): ');

% Creating required number of monomers 

for i = 1:num_of_mon
    
    %monomer parameters
    mon_name(i) = input('Enter the monomer name (Single Character):','s');
    freedom = input('Enter the freedom of monomer(free/pinned)','s');
    freedom_check = isequal(freedom,'pinned');
    
    formatSpec_freedom = 'mon : %s : freedom : %s\r\n';
    fprintf(file, formatSpec_freedom, mon_name(i), freedom);
    
    if (freedom_check == 1)
        pinned_rangefrom = input('Enter the pinned range from: ');
        pinned_rangeto = input('Enter the pinned range to: ');
        
        formatSpec_pin_range = 'mon : %s : pinned_range : %d;%d\r\n';
        fprintf(file, formatSpec_pin_range, mon_name(i), pinned_rangefrom, pinned_rangeto);
    end
    
    spec_interaction = input('Want to specify Chi parameter? (y/n): ','s');
    interaction_check = isequal(spec_interaction,'y');

    if(interaction_check == 1)
        int_with = input('This monomer interacts with (Enter mon name): ','s');
        chival = input('Enter the chi value: ');
        formatSpec_freedom = 'mon : %s : chi - %s : %.4f\r\n';
        fprintf(file, formatSpec_freedom, mon_name(i), int_with, chival);
    end
    
end
fprintf(file,'\r\n');


% Creating Molecules from monomers
disp('**********************')
disp('NOW CREATING MOLECULES')
disp('**********************')

num_of_mol = input('Enter the number of molecules required (integer): ');

for i = 1:num_of_mol
    test = input('Enter molecule with (single/two) monomer: ','s');
    surfactant = isequal(test,'two');
    
    if (surfactant == 0)
        %monomer parameters
        mol_name(i) = input('Enter the molecule name (Single Character):','s');
        composition = input('Enter number of monomers to form a molecule: ');
        freedom = input('Enter the freedom of monomer(restricted/solvent): ','s');
        freedom_check = isequal(freedom,'restricted');
    
        formatSpec_comp = 'mol : %s : composition : (%s)%d\r\n';
        formatSpec_freedom = 'mol : %s : freedom : %s\r\n';
    
        fprintf(file, formatSpec_comp, mol_name(i), mol_name(i), composition);
        fprintf(file, formatSpec_freedom, mol_name(i), freedom);
    
        if (freedom_check == 1)
            theta = input('Enter theta value: ');
    
            formatSpec_th = 'mol : %s : theta : %d\r\n';
            fprintf(file, formatSpec_th, mol_name(i), theta);
        end
    end
    
    if (surfactant == 1)
        surf_name = input('Enter the surfactant name (Single Character):','s');
        compos1 = input('Enter number of first monomers in surfactant: ');
        compos2 = input('Enter number of second monomers in surfactant: ');
        freedom = input('Enter the freedom of monomer(restricted/solvent): ','s');
        freedom_check = isequal(freedom,'restricted');
    
        formatSpec_comp = 'mol : %s : composition : (%s)%d(%s)%d\r\n';
        formatSpec_freedom = 'mol : %s : freedom : %s\r\n';
    
        fprintf(file, formatSpec_comp, surf_name, mol_name(i-2), compos1,mol_name(i-1), compos2);
        fprintf(file, formatSpec_freedom, surf_name, freedom);
    
        if (freedom_check == 1)
            theta = input('Enter theta value: ');
            formatSpec_th = 'mol : %s : theta : %d\r\n';
            fprintf(file, formatSpec_th, surf_name, theta);
        end    
        
        
    end
    
end
fprintf(file,'\r\n');
fprintf(file,'start\r\n');
fprintf(file,'mon : A : freedom : free\r\n');
fprintf(file,'\r\n');

disp('***************************')
disp('WRITING ITERATION PARAMTERS')
disp('***************************')

fprintf(file, 'newton : isaac : method : pseudohessian\r\n');
fprintf(file, 'newton : isaac : tolerance : 1e-10\r\n');
fprintf(file, 'newton : isaac : e_info : false\r\n');
fprintf(file, 'newton : isaac : s_info : true\r\n');
fprintf(file,'\r\n');


disp('*****************')
disp('OUTPUT GENERATION')
disp('*****************')

fprintf(file, 'output : filename.pro : type : profiles\r\n');
fprintf(file, 'output : filename.pro : template : temp.pro\r\n');
fprintf(file, 'output : filename.pro : write_bounds : false\r\n');
fprintf(file, 'output : filename.kal : type : kal\r\n');
fprintf(file, 'output : filename.kal : template : temp.kal\r\n');
fprintf(file,'\r\n');


disp('*****************')
disp('OUTPUT GENERATION')
disp('*****************')

super_iteration = input('Activate Super Iteration? (y/n):','s')
super_iteration = isequal(super_iteration,'y');
if(super_iteration == 1)
    variable = input('Enter Super Molecule :','s');
    parameter = input('Iteration paramter :','s');
    value = input('Value to Iterate: ');
    
    formatSpec_si = 'sys : %s : super_iteration : true\r\n';
    formatSpec_sm = 'sys : %s : super_molecule : %s\r\n';
    formatSpec_sf = 'sys : %s : super_function : %s\r\n';
    formatSpec_sfv = 'sys : %s : super_function_value : %.16f\r\n';
    
    fprintf(file,formatSpec_si, gridname);
    fprintf(file,formatSpec_sm, gridname, variable);
    fprintf(file,formatSpec_sf, gridname, parameter);
    fprintf(file,formatSpec_sfv, gridname, value);
    
end


fread = fileread('test.in');
fopen('newfile.in','w');
dlmwrite('newfile.in',fread,'delimiter','');




