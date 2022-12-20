clear; 
close all;

%% Image File Names
% yellow : 1-10
% red : 11-20
% white + yellow : 21-30
% white + red : 31-40
% green : 41-45
% blue : 46-50
% orange : 51-55

filenames = { % corresponding k / index values to choose file
    'stopAhead_1324866399.avi_image4.png'; % 1
    'laneEnds_1324867138.avi_image3.png'; % 2
    'merge_1324867161.avi_image1.png'; % 3
    'speedLimit_1323896613.avi_image27.png'; % 4
    'signalAhead_1323896726.avi_image26.png'; % 5
    'dip_1323804622.avi_image0.png'; % 6
    'intersection_1324866305.avi_image1.png'; % 7
    'pedestrian_1323896918.avi_image17.png'; % 8
    'addedLane_1323820177.avi_image1.png'; % 9
    'yieldAhead_1323821551.avi_image17.png'; % 10
    'stop_1323812975.avi_image21.png'; % 11
    'stop_1323896588.avi_image26.png'; % 12
    'stop_1324866406.avi_image13.png'; % 13
    'stop_1324866481.avi_image20.png'; % 14
    'stop_1323896696.avi_image7.png'; % 15
    'stop_1323821112.avi_image27.png'; % 16
    'stop_1323821086.avi_image14.png'; % 17
    'stop_1323812975.avi_image18.png'; % file formats from here [2]{k}.png
    'stop_1323823007.avi_image19.png';
    'stop_1323824828.avi_image20.png';
    'square_yellow_21.png';
    'circle_triangle_yellow_22.jpg';
    'diamond_dark_yellow_23.jpg';
    'triangle_yellow_24.jpg';
    'square_triangle_yellow_25.jpg';
    'diamond_squre_yellow_26.jpg';
    'diamond_yellow_27.jpg';
    'diamond_yellow_28.jpg';
    'square_yellow_29.jpg';
    'square_yellow_30.jpg';
    'traingular_red_31.jpg';
    'traingular_red_32.jpg';
    'octagonal_red_33.jpg';
    'cricular_red_34.jpg';
    'cricular_white_red_35.jpg';
    'triangular_white_red_36.jpg';
    'rectangular_red_37.jpg';
    'triangular_white_red_38.jpg';
    'cricular_white_red_39.jpg';
    'triangular_white_red_40.jpg';
    'rectangular_white_green_41.jpg';
    'rectangular_white_green_42.jpg';
    'rectangular_white_green_43.jpg';
    'rectangular_white_green_44.jpg';
    'rectangular_white_green_45.jpg';
    'rectangular_white_blue_46.jpg';
    'rectangular_white_blue_47.jpg';
    'rectangular_white_blue_48.jpg';
    'rectangular_white_blue_49.jpg';
    'rectangular_white_blue_50.jpg';
    'rectangular_white_orange_51.jpg';
    'rectangular_white_orange_52.jpg';
    'rectangular_white_orange_53.jpg';
    'rectangular_white_orange_54.jpg';
    'rectangular_white_orange_55.jpg';
};

%% Load image
k = 45;
im = imread(strcat('img/',filenames{k}));
figure
imshow(im)

%% Color Enhancement
im_eq = colorEnhance(im);

%% Color Segmentation
if (k >= 11 && k <= 20) || (k >= 31 && k <= 40)
    % Red color detection
    im_th = hsiThreshR(im_eq);
    hsv = rgb2hsv(im);
    im_th = hsv(:,:,1)>60/179&hsv(:,:,1)<130/179&im_th;
elseif (k >= 1 && k <= 10) || (k >= 21 && k <= 30)
    % Yellow color detection
    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>22/179&hsv(:,:,1)<38/179;
elseif k >= 41 && k <= 45
    % Green color detection
    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>38/179&hsv(:,:,1)<75/179;
elseif k >= 46 && k <= 50
    % Blue color detection
    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>75/179&hsv(:,:,1)<130/179;
elseif k >= 51 && k <= 55
    % Orange color detection
    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>1/179&hsv(:,:,1)<22/179;
end

im_bw = imclose(im_th,ones(15,15));
im_bw = imfill(im_bw,'hole');
im_bw = bwareaopen(im_bw,90);

figure
imshow(im_bw)
hold on

[I,n] = bwlabel(im_bw);

%% Edge detection
score_min = 1e4;
for i = 1:n
    [y,x] = find(I==i);
    if isempty(y)
        continue
    end
    xmin = max(1,min(x)-10); xmax = min(max(x)+10,size(im,2));
    ymin = max(1,min(y)-10); ymax = min(max(y)+10,size(im,1));

    figure(3)
    rectangle('Position',[xmin ymin xmax-xmin ymax-ymin],'EdgeColor','b')
    
    reg_rgb = im(ymin:ymax, xmin:xmax,:);

    % multiple green signs
    if k==41 || k == 42 || k == 55 || k == 45
      figure
      imshow(reg_rgb)
    end

    reg = im2double(rgb2gray(reg_rgb));
    [reg_edge,th] = edge(reg,'canny');
    disp(th)
    
    if diff(th)<0.04
        continue
    end

    % Hough transform
    [H,theta,rho] = hough(reg_edge,'Theta',linspace(-90,89.9,500));

    % Detect peaks in Hough transform
    peakNum = 50;
    P = houghpeaks(H, peakNum, 'threshold', ceil(0.4*max(H(:))));
    lines = houghlines(im_bw, theta, rho, P, 'FillGap', 5, 'MinLength', 1);
    thetaPeaks = theta(P(:, 2));
    rhoPeaks = rho(P(:,1));

    T = clusterdata(thetaPeaks',5);
    C = [];
    for j = 1:max(T)
        C = [C mean(thetaPeaks(T==j))];
    end

    C = sort(C);
    score = norm(C-[-90:45:90]);
    disp(score)

    if score < score_min
        score_min = score;
        isign = i;
    end
end

%% Final detection result
[y,x] = find(I==isign);
xmin = max(1,min(x)-10); xmax = min(max(x)+10,size(im,2));
ymin = max(1,min(y)-10); ymax = min(max(y)+10,size(im,1));

figure(3)
rectangle('Position',[xmin ymin xmax-xmin ymax-ymin],'EdgeColor','b')
reg_rgb = im(ymin:ymax, xmin:xmax,:);
figure
imshow(reg_rgb)