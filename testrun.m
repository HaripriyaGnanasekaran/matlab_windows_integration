

fread = fileread('input.dat')


for i = 1:2
filename = 'input.txt'
string = sprintf('!sfbox.exe %s', filename);
eval(string)
end