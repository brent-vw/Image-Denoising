
function noise()

noiseMaker = {
    {'0_original' @(I) I},
    {'1_poisson', @(I) imnoise(I, 'poisson')},
    {'2_speckle', @(I) imnoise(I, 'speckle')},
    {'3_saltpepper_0-1', @(I) imnoise(I, 'salt & pepper', 0.1)},
    {'4_gaussian_0_0-1', @(I) imnoise(I, 'gaussian', 0, 0.1)},
    {'5_gaussian_0_0-5', @(I) imnoise(I, 'gaussian', 0, 0.5)},
    {'6_hor._stripes_w3_p8_s1_f0', @(I) addStripes(I, 3, 8, 1, 0)},
    {'7_hor._stripes_w1_p10_s1_f0', @(I) addStripes(I, 1, 10, 1, 0)},
    {'8_vert._stripes_w3_p8_s1_f0', @(I) permute(addStripes(permute(I, [2 1 3]), 3, 8, 1, 0), [2 1 3])},
    {'9_stripes_w3_p8_s1_f0', @(I) permute(addStripes(permute(addStripes(I, 3, 8, 1, 0), [2 1 3]), 3, 8, 1, 0), [2 1 3])},
    
};

files = dir(['original/' '*.tiff']);
for target = files(:)'
    target = target.name;
    for color = [true false]
        target_folder = strsplit(target, '.');
        target_folder = target_folder{1};

        image = imread(['original/' target]);
        
        [~,~,s] = size(image);
        if(s == 4)
            image(:,:,4) = [];
        end
        
        if(~color)
            target_folder = [target_folder '/'];
            image = rgb2gray(image);
        else
            target_folder = [target_folder '_color/'];
        end

        [~] = rmdir(['noisy/' target_folder], 's');
        mkdir(['noisy/' target_folder])

        for i = 1:length(noiseMaker)
           item = noiseMaker{i};
           name = item{1};
           f = item{2};
           I = f(image);
           imwrite(I, ['noisy/' target_folder name '.png']);

        end
    end
end
end

function image = addStripes(image, width, period, start, factor)
    start = mod(start-1, period) + 1;
    [~, ~, n] = size(image);
    for i = start:period:size(image, 1)-(width-1)
        for j = 1:n
            image(i:i+(width-1), :, j) = factor*image(i:i+(width-1), :, j);
        end
    end
end
