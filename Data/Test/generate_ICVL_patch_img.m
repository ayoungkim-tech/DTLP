% Generate ICVL patch image for testing DTLP
clear all; clc

% Read image files
img_dir = 'Simulation_data\ICVL_test_data';
files = dir(fullfile(img_dir, '*.mat'));
file_names = {files.name};
n_test_img = numel(files);
img_sz = [582,528];
count = 0;

% Set image index and option how to generate the image
i = 9;
opt = 1;

% load image
filename = files(i).name;
load(['Simulation_data\ICVL_test_data\',filename]);
hyper_image = single(rad);
hyper_image = rot90(hyper_image);

% normalize the Iin vals
hyper_image = hyper_image ./max(hyper_image(:));

if opt ==1
    % Option 1: Resize image
    hyper_image = imresize(hyper_image,img_sz);
    file_dir = 'ICVL_patch_rot90';
elseif opt ==2
    % Option 2: Crop image
    orig_sz = size(hyper_image);
    hyper_image = hyper_image(orig_sz(1)/2-img_sz(1)/2:orig_sz(1)/2+img_sz(1)/2-1,orig_sz(2)/2-img_sz(2)/2:orig_sz(2)/2+img_sz(2)/2-1,:);
    file_dir = 'ICVL_crop+patch_rot90';
end

% initalize patch image param
patch_image = zeros(48,48,31,462);

% generate patch image
for x=1:24:img_sz(1)-24-31
    for y =1:24:img_sz(2)-24
        count = count+1;
        for ch = 1:31
            patch_image(:,:,ch,count) = hyper_image(x+ch-1:x+ch-1+47,y:y+47,ch);
        end
    end
end
patch_image = single(patch_image);

% save the hyper image and patch image
save([img_dir,'\',file_dir,'\',num2str(i),'.mat'], "hyper_image", "patch_image")