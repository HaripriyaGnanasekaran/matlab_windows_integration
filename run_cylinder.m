% Runs the created input files.
% Input files are created using create_input.m

for i = 1:n
     filename = sprintf('input_cylinder_%d.dat',i);
     string = sprintf('sfbox.exe %s', filename);
     system(string);
end

