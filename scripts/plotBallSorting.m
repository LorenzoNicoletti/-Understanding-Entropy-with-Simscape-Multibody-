function plotBallSorting(out)
% Description: 
% This function plots the sorting level of the balls over time. The sorting level
% goes from 0 to 10 (each ball can contribute by 1 or 0 points).
% The function assigns a score based on how well the balls are sorted:
% - If a red ball lays on the left side of the model, it gets 1 point (otherwise 0)
% - If a blue ball lays on the right side of the square, it gets 1 point (otherwise 0)
% At the beginning all red balls are on the left side and all blue balls
% are on the right one. This means a perfect sorting and a total of 10
% points. If ALL red balls are on the right side and ALL blue balls are on
% the left side this corresponds to 0 points.
% THIS FUNCTION CREATES A DYNAMIC PLOT
%-----------------
% Inputs:      
% out:      The variable where the results of the Simulink model are stored
%-----------------
% Example:
% Provided that the model has been simulated, the energy can be plotted by calling: 
% plotBallSorting(entropyModelOut)
%-----------------
% Lorenzo Nicoletti, 16.06.2024, Munich, Germany
%-----------------

%% Implementation

%% 1) Collect the sorting level from the model
% Number of balls: If you changed the number of balls in the model, you have to update this value!
numBalls = 10;

% Create a figure:
figure('Color','w'); grid on; hold on

% Use for the calculation the number of balls on the right side
simTime          = squeeze(out.logsout.get('ballCombinations').Values.Time);
ballCombinations = squeeze(out.logsout.get('ballCombinations').Values.Data)';

% Sorting level
sortingLevel = sum(ballCombinations,2);

for i = 1:numel(simTime)
    % Calculate the number of states W using the binomial coefficient
    W = nchoosek(numBalls, sortingLevel(i));
end

%% 2) Calculate the sorting level statistically
% This step calculates the number of combinations of sorting level for the
% given number of balls. The result is 2^numBalls combinations
theohist = [];
for i=0:numBalls
    theohist = [theohist,i*ones(1,nchoosek(numBalls,i))];
end

%% 3) Plot the results
% Plot the theoretical distribution
histogram(theohist,'Normalization','probability','FaceColor',[0,75,135]/255,'FaceAlpha',1,'EdgeColor',[215,136,36]/255,'LineWidth',1.5);

% Plot the actual distribution
histogram(sortingLevel,'Normalization','probability','FaceColor',[1,1,1],'FaceAlpha',0.5,'LineWidth',1.5,'LineStyle',':');

% Labels and title
xlabel('Number of sorted balls'); ylabel('Probability'); title('Ball sorting');

% Set Tick labels
ax = gca; ax.XLim = [0-0.5,numBalls+0.5];
ax.XTick = 0:1:numBalls;
ax.XTickLabels = num2cell(0:1:numBalls);


% Add legend
legend('Theoretical Sorting','Actual Sorting');

end