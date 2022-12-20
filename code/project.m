% EE 368
% Project
% Shiwen Zhang
clear; close all;
filename = {'stopAhead_1324866399.avi_image4.png';
            'laneEnds_1324867138.avi_image3.png';
            'merge_1324867161.avi_image1.png';
            'speedLimit_1323896613.avi_image27.png';
            'signalAhead_1323896726.avi_image26.png';
            'dip_1323804622.avi_image0.png';
            'intersection_1324866305.avi_image1.png';
            'pedestrian_1323896918.avi_image17.png';
            'addedLane_1323820177.avi_image1.png';
            'yieldAhead_1323821551.avi_image17.png';
            'stop_1323812975.avi_image21.png';
            'stop_1323896588.avi_image26.png';
            'stop_1324866406.avi_image13.png';
            'stop_1324866481.avi_image20.png';
            'stop_1323896696.avi_image7.png';
            'stop_1323821112.avi_image27.png';
            'stop_1323821086.avi_image14.png';
            'stop_1323812975.avi_image18.png';
            'stop_1323823007.avi_image19.png';
            'stop_1323824828.avi_image20.png';
            'test.jpg'};
            
%% Load image
% choose image
% yellow warning signs: k = 1-10
% red stop signs: k = 11-20
k = 3;
im = imread(filename{k});
figure
imshow(im)
%% Color Enhancement
im_eq = colorEnhance(im);
%% Color Segmentation
if k == 21
    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>1/179&hsv(:,:,1)<10/179;
elseif k > 10
    % Red color detection
    im_th = hsiThreshR(im_eq);
    hsv = rgb2hsv(im);
    im_th = hsv(:,:,1)>60/179&hsv(:,:,1)<130/179&im_th;
else
    
    
    % Yellow color detection
    % Hue values of basic colors
    % Orange  0-22 - done
    % Yellow 22- 38 - done
    % Green 38-75 - done
    % Blue 75-130 - done
    % Violet 130-160
    % Red 160-179 - done

    hsv = rgb2hsv(im_eq);
    im_th = hsv(:,:,1)>24/179&hsv(:,:,1)<28/179;
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
    if k==20
      figure
     imshow(reg_rgb)
    end
    reg = im2double(rgb2gray(reg_rgb));
    [reg_edge,th] = edge(reg,'canny');
    disp(th)
    if diff(th)<0.04
        continue
    end

    figure
    imshow(reg_edge)
    
    % Hough transform
    [H,theta,rho] = hough(reg_edge,'Theta',linspace(-90,89.9,500));
    figure
    imagesc(H, 'XData', theta, 'YData', rho);
    axis on, axis normal, hold on;
    colormap(hot), colorbar
    xlabel('\theta [deg]'); ylabel('\rho');
    
    % Detect peaks in Hough transform
    peakNum = 50;
    P = houghpeaks(H, peakNum, 'threshold', ceil(0.4*max(H(:))));
    lines = houghlines(im_bw, theta, rho, P, 'FillGap', 5, 'MinLength', 1);
    thetaPeaks = theta(P(:, 2));
    rhoPeaks = rho(P(:,1));
     plot(thetaPeaks, rhoPeaks, 'ys', 'LineWidth', 2,'markersize',10);
    
    
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