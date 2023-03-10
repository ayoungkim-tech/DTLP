% Test original tiling of patch_image
t = tiledlayout(22,21,'TileSpacing', 'none', 'Padding', 'none');
nexttile(1);
imshow(patch_image(1:24,1:24,15,1));
for i = 2: 462
    nexttile(i);
    imshow(patch_image(25:end,25:end,15,i))
end

figure(); imshow(hyper_image(:,:,15));