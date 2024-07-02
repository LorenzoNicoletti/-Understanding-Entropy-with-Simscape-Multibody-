function [xCoords, yCoords] = sortBallsWithinRange(numElments,radius,rangeX,rangeY)
% Description: 
% This function sorts a given number of balls within an enclosed
% rectangular space (defined by rangeX and rangeY). The function ensures
% that the balls are randomly distributed within the space and that they do
% not collide with each other.
%-----------------
% Inputs:    
% numElments:[1x1 int]     The number of spheres to be sorted
% radius:    [1x1 double]  The radius of the spheres (in m)
% rangeX:    [1x1 double]  Available space for the spheres along X (in m)
% rangeY:    [1x1 double]  Available space for the spheres along Y (in m)
%-----------------
% Outputs: 
% xCoords:    [numElmentsx1 double]  The coordinates of the spheres along X (in m)
% yCoords:    [numElmentsx1 double]  The coordinates of the spheres along Y (in m)
%-----------------
% Example:
% [xCoords, yCoords] = sortBallsWithinRange(5,0.2,5,10);
%-----------------
% Lorenzo Nicoletti, 16.06.2024, Munich, Germany
%-----------------

%% Implementation:

%% 1) Calculate first distribution:
% Distribute the elements in a random fashion. We have to restrict the
% rangeX and rangeY to avoid collision with the borders
xCoords = rand(numElments, 1) * (rangeX-2*radius);
yCoords = rand(numElments, 1) * (rangeY-2*radius);

% Along Y, the 0 is in the middle (see multibody model). This means that by giving a rangeY of 10
% for example, the actual range is [-5,5]. We can use 10 as a rangeY value
% and correct the final coordinates by translating the elements by 5
yCoords = yCoords-(rangeY-2*radius)/2;

%% 2) Calculate the minimum distance between elements
% Calculate the distance between all particles along X
diffMatrixX = abs(repmat(xCoords,[1,numElments])-repmat(xCoords',[numElments,1]));

% Calculate the distance between all particles along Y
diffMatrixY = abs(repmat(yCoords,[1,numElments])-repmat(yCoords',[numElments,1]));

% By summing Y and X we get the total distance between the speheres
distMatrix = (diffMatrixY.^2+diffMatrixX.^2).^0.5;

% The elements of the diagonal represent the distance between the sphere
% and itself, therefore they are always zero. We substitute them with NaN
% so that they are not considered in the search of the minimum distance
distMatrix = distMatrix + diag(repmat(NaN,[1,5]));

%% 3) Check if there is any collision
collision = any(any(distMatrix<radius*2));

%% 4) Sort as long as the flag is active
if collision==1
    [xCoords, yCoords] = sortBallsWithinRange(numElments,radius,rangeX,rangeY);
end
end