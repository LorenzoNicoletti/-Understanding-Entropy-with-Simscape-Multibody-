function createGIF(frames,varargin)
% frames: The frames that you want to create from the figure, generated
%         with the function getframe(gcf)
% gifName: The name of the gif. Needs to be a char which ends with .gif
% delayTime: Delay time between frame. Will define how long the GIF is

%% 0) Generate the inputs
% Create Input Parser Object
p = inputParser;

% Define variables that are always required
addRequired(p,'frames')

% Define the optional inputs with their default values
addOptional(p, 'gifName', 'animation.gif');
addOptional(p, 'delayTime',1e-3);

% Parse optional and required input
parse(p, frames,varargin{:});

% Define variables locally
gifName      = p.Results.gifName;
delayTime    = p.Results.delayTime;

for i = 1:numel(frames)
    
    im = frame2im(frames(i));
    [imind, cm] = rgb2ind(im, 256);

    if i==1
        imwrite(imind, cm, gifName, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
    else
        imwrite(imind, cm, gifName, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end