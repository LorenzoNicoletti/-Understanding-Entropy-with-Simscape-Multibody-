function plotkineticEnergy(out,massBall)
% Description: 
% This function calculates and plots the kinetic energy of the system over
% time. The kinetic energy is calculated by adding up the energy of each
% one of the 10 balls. Except for the moments where a collision occurs (and
% some portion of the energy is stored in the elastic deformation) the
% overall kinetic energy should remain constant (provided that damping and
% friction are deactivated during the simulation).
%-----------------
% Inputs:      
% out:      The variable where the results of the Simulink model are stored
% massBall: The mass of the ball used for the simulation
%-----------------
% Example:
% Provided that the model has been simulated, the energy can be plotted by calling: 
% plotkineticEnergy(entropyModelOut,massBall)
%-----------------
% Copyright 2023 - 2024 The MathWorks, Inc.
%-----------------

%% Collect the data:
% Identify the blocks containint the ball models, rename them so that they can be called with dynamic strings from the out variable:
ballSubsysRef = strrep(strrep(Simulink.SubsystemReference.getAllInstances('entropyModel'),'entropyModel/',''),' ','_');

% Collect the time vector
simTime = out.simlog.(ballSubsysRef{1}).vx.I.series.time;

% Allocate a vector for the square of speed. This vector will store the sum
% of the squares of all speed of all spheres and is therefore directly
% proportional to the kinetic energy
vtotSquared = zeros(numel(simTime),1);

% Loop through all the spheres and calculate the squared sum of all
% spheres velocities:
for i = 1:numel(ballSubsysRef)

    vx = out.simlog.(ballSubsysRef{i}).vx.I.series.values;
    vz = out.simlog.(ballSubsysRef{i}).vz.I.series.values;
    
    vtotSquared = vtotSquared + (vx.^2+vz.^2);
end

%% Plot the results:

figure('Units','centimeters','Position',[0,0,29.98,12.92]); grid on; hold on;
plot(simTime, 10*0.5*massBall*vtotSquared,'LineWidth',1.5);
xlabel('Time in seconds');
ylabel('Energy in Joules');
title('Kinetic energy over time (should remain constant)');

end