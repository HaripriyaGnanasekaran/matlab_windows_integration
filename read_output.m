% Reads the output files generated using SFbox.
% Contains functions to plot data and analyse data.


for i = 1:n
     filename = sprintf('input_%d_2.pro',i);
     M = dlmread(filename,'\t',1,0);
     layers(:,i) = M(:,1);
     phi_A(:,i) = M(:,2);
     phi_B(:,i) = M(:,3);
     phi_p(:,i) = M(:,4);
     phi_pa(:,i) = M(:,5);
     phi_pb(:,i) = M(:,6);
end



% plotting profiles

for i = 1:n
     figure(i);
     plot (layers(:,i),phi_A(:,i),layers(:,i),phi_B(:,i),...
         layers(:,i),phi_p(:,i),...
         layers(:,i),phi_pa(:,i),...
         layers(:,i),phi_pb(:,i));
     xlabel('x')
     ylabel('\phi')
     legend('\phi_A','\phi_B','\phi_S','\phi_{SA}','\phi_{SB}');
end
