clear all; clc; warning off;
addpath(genpath('..\..\HSI2RGB-master'));

train_data = "Harvard";
test_data = "ICVL10_resize";
img_dir = "Result\"+train_data+"_271Ckpt_11Phase_400Epoch_0.00010Learnrate_4Rank\"+test_data+"\";
files = dir(fullfile(img_dir, "*.mat"));

%Remove file which is not result image
file_names = {files.name};
idx = find(strcmp(file_names, 'psnr_vals.mat'));
files(idx) = [];
idx = find(strcmp(file_names, 'psnr_vals_256.mat'));
files(idx) = [];

n_test_img = numel(files);

psnr_vals = zeros(1,n_test_img);
psnr_vals_256 = zeros(1,n_test_img);
for i = 1:n_test_img
    filename = files(i).name;
    load([img_dir+filename]);

    % Input and output, rgb images
    lambda_MS = (400:10:700);
    [ydim,xdim,zdim]=size(gt_image);
    % reorder data so that each column holds the spectra of of one pixel
    % use the D65 illuminant
    illuminant=65;
    % do minor thresholding
    threshold=0.001;
    %Create the RBG image,
    Z = reshape(gt_image,[],zdim);
    Iin_rgb = HSI2RGB(lambda_MS,Z,ydim,xdim,illuminant,threshold);

    % Results
    Z = reshape(rec_image,[],zdim);
    Iout_rgb = HSI2RGB(lambda_MS,Z,ydim,xdim,illuminant,threshold);
    psnr_val = psnr(double(gt_image), rec_image);
    psnr_vals(i) = psnr_val;
    psnr_val_256 = psnr(double(gt_image(128:256+128-1,128:256+128-1,:)), rec_image(128:256+128-1,128:256+128-1,:));
    psnr_vals_256(i) = psnr_val_256;

    figure(1);
    imshow([Iin_rgb Iout_rgb])
    title(num2str(psnr_val))
end

save([img_dir+"psnr_vals.mat"],"psnr_vals")
round(mean(psnr_vals),2)
save([img_dir+"psnr_vals_256.mat"],"psnr_vals_256")
round(mean(psnr_vals_256),2)