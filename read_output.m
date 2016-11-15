% Reads the output files generated using SFbox.
% Contains functions to plot data and analyse data.


%pre-allocation for fast processing of arrays
% layers = zeros(n_layers,n);
% phi_A = zeros(n_layers,n);
% phi_B = zeros(n_layers,n);
% phi_p = zeros(n_layers,n);
% phi_pa = zeros(n_layers,n);
% phi_pb = zeros(n_layers,n);

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
     fig = figure(i);
     plotname = sprintf('profile_%d',i);
     plot (layers(:,i),phi_A(:,i),layers(:,i),phi_B(:,i),...
         layers(:,i),phi_p(:,i),...
         layers(:,i),phi_pa(:,i),...
         layers(:,i),phi_pb(:,i));
     xlabel('x')
     ylabel('\phi')
     legend('\phi_A','\phi_B','\phi_S','\phi_{SA}','\phi_{SB}');
     print(fig,plotname,'-dpng')
     
end

