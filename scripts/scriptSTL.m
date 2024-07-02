% Use stlread to load the STL file
[F, V] = stlread('labelLeftSide.STL');% F contains the face data, V contains the vertex data

F2.Points = F.Points*0.15;
F2.ConnectivityList = F.ConnectivityList;

TR = triangulation(F2.ConnectivityList,F2.Points);

% Find how to translate the labels as needed: 
XValue = (max(F2.Points(:,1))-min(F2.Points(:,1)))/2;
YValue = (max(F2.Points(:,2))-min(F2.Points(:,2)))/2;

stlwrite(TR,'leftLabel.stl')



% Use stlread to load the STL file
[F, V] = stlread('labelRightSide.STL');% F contains the face data, V contains the vertex data

F2.Points = F.Points*0.15;
F2.ConnectivityList = F.ConnectivityList;

TR = triangulation(F2.ConnectivityList,F2.Points);

% Find how to translate the labels as needed: 
XValue = (max(F2.Points(:,1))-min(F2.Points(:,1)))/2;
YValue = (max(F2.Points(:,2))-min(F2.Points(:,2)))/2;

stlwrite(TR,'rightLabel.stl')