% Runs the created input files.
% Input files are created using create_input.m

parfor i = 1:n
     filename = sprintf('input_%d.dat',i);
     string = sprintf('sfbox.exe %s', filename);
     system(string);
end

