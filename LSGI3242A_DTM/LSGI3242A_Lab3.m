clc
clear

% Generate linear z, random y, and linear x with noise. x is correlated to z
x = 100 * rand(100,1);
x = sort(x);
y = 100 * rand(100,1);
z = [0:99]';
data = [x y z];

%% Plot original data (2x2, #1 image)
figure;
subplot(2,2,1)
s = scatter3(x,y,z, 40, z, 'filled');
% label x y z axis
xlabel('X', 'FontSize', 20);
ylabel('Y','FontSize', 20);
zlabel('Z','FontSize', 20);
title('Original data','FontSize', 20);
colorbar

%% 2nd order polynomial interpolation
subplot(2,2,2)
% Find polynomial coefficients
A = [ones(size(data,1),1) x y x.*y x.^2 y.^2];
a = A\z;

% Calculate height for each point
poly_x = [0: 2: 99]';
poly_y = poly_x;
poly_z = zeros(size(poly_x,1));

% the array is accessed by (Row, Column)
for r = 1:size(poly_y,1)
    for c = 1:size(poly_x,1)

        poly_z(r,c) = [1 poly_x(c) poly_y(r) poly_x(c).*poly_y(r) poly_x(c).^2 poly_y(r).^2]*a;
    end
end

%% Plot graph 
% 3D mesh grid
s = mesh(poly_x, poly_y, poly_z);
s.FaceColor = 'flat';
% label x y z axis
xlabel('X', 'FontSize', 20);
ylabel('Y','FontSize', 20);
zlabel('Z','FontSize', 20);
% give a title 
title('2nd Order Polynomial Interpolation','FontSize', 20);
% show the range of elevation value
colorbar

%% Weighted Averaging graph
subplot(2,2,3)

wavg_x = [0: 2: 99]';
wavg_y = wavg_x;
% z for weighted averaging
wavg_z = zeros(size(wavg_x,1));

% Find the nearest 5 points
n = 5;
for r = 1:size(wavg_x,1)
    for c = 1:size(wavg_x,1)
        d2 = (c-x).^2 + (r-y).^2;
        % a for sorted values, b for indexes
        [sorted_d,index] = sort(d2);
        w = (sorted_d(1:n)).^-1;
        wz = w .* z(index(1:n));
        % grid z for weighted averaging
        wavg_z(r,c) = sum(wz)/sum(w);
    end
end

s = mesh(wavg_x, wavg_y, wavg_z);
s.FaceColor = 'flat';
% label x y z axis
xlabel('X', 'FontSize', 20);
ylabel('Y','FontSize', 20);
zlabel('Z','FontSize', 20);
% give a title 
title('Weighted Averaging','FontSize', 20);
% show the range of elevation value
colorbar

%% Deviation graph
subplot(2,2,4)
% 3D mesh grid
dev_z = poly_z - wavg_z;

s = mesh(poly_x, poly_y, dev_z);
s.FaceColor = 'flat';
% label x y z axis
xlabel('X', 'FontSize', 20);
ylabel('Y','FontSize', 20);
zlabel('Deviation','FontSize', 20);
% give a title 
title('Comparison of Two Surfaces','FontSize', 20);
% show the range of elevation value
colorbar

sgtitle('Wong\_12345678D','FontSize', 30)