% Author - Rajdeep Pinge
% Date - 6th April, 2017

% Reference - Code written by Omkar Damle for Basic Majority model

% Code to simulate effect of radicals on dynamics of voters

clear;
close all;
clc;

p = [0 0 0 1 1 1];      %probability function
n = 50;                         %n*n matrix
T = 10000;                      %time steps

c = 2;                      % number of colors
colormap(gray(c))              % use this with c=2!!!
X=ceil(c*rand(n));              % initial state: random values: 1,2,...,c

initialProb2 = [0.3 0.4 0.5 0.6 0.7];   % initial probability of opinion 0
[row,col] = size(X);

% percentage of radicals of opinion 0 in total population
%fractRadicals = [floor(initialProb2*100/4)/100 floor(initialProb2*100/2)/100 initialProb2];   % 1% radicals
fractRadicals = [0 0.1 0.2 0.3];

% matrix to store final density of opinion for all initial probabilities
% and for all percentages of radicals
count0arr = zeros(numel(initialProb2), numel(fractRadicals));

% loop over different initial probabilities
for ip = 1:numel(initialProb2)
    
    % matrices to store exact locations of specific opinions in the grid
    op1_pts = [];
    op2_pts = [];

    % generate grid
    for i=1:row
        for j=1:col
            u=rand;     % uniform random variable

            if u<initialProb2(ip)   % opinion 0 is given label 2
                X(i,j) = 2;
                op2_pts = [op2_pts;[i j]];
            else
                X(i,j) = 1;           
                op1_pts = [op1_pts;[i j]];
            end

        end
    end

    % store the grid generated for later use
    Y = X;

    % loop for different no of radicals
    for fr = 1:numel(fractRadicals)

        % get the initial grids
        X = Y;

        
        if fr ~= 1
            fanatics_op0 = zeros(min(size(op2_pts, 1)/(n*n),fractRadicals(fr))*n*n, 2);   % fanatics of opinion 0
            %fanatics_op0 = zeros(fractRadicals(fr)*n*n, 2);

            % choose random points of opinion 0 to be radicals
            op2_pts_perm = op2_pts(randperm(size(op2_pts, 1)), :);

            for idx = 1:size(fanatics_op0, 1)
               fanatics_op0(idx,:) = op2_pts_perm(idx, :); 
            end

        end

    axis square

    % simulation
    for t=1:T

        u1=randi(n);
        u2=randi(n);   %uniformly at random in 2d

        if fr == 1 || ~ismember([u1, u2], fanatics_op0, 'rows')
            %can be optimised for only one point
            Z(1,:,:)=X;
            Z(2,:,:)=X(:,[n 1:n-1]);           % states of neighbors left
            Z(3,:,:)=X(:,[2:n 1]);              % states of neighbors right
            Z(4,:,:)=X([n 1:n-1],:);           % states of neighbors above
            Z(5,:,:)=X([2:n 1],:);              % states of neighbors below

            % apply majority rule
            
            sum = Z(1,u1,u2)+Z(2,u1,u2)+Z(3,u1,u2)+Z(4,u1,u2)+Z(5,u1,u2) - 5;

            u = rand;

            if u<p(sum+1)
                X(u1,u2) = 2;
            else
                X(u1,u2) = 1;
            end
        end

    end

    % keep the count of both opinions
    
    count = zeros(c);

    for i=1:row
        for j=1:col
            count(X(i,j)) = count(X(i,j))+1;
        end
    end

    % store the count in array
    count0arr(ip, fr) = count(2, 1) / (n*n);

    end
end

% plot graph of density of opinion 0
plot(initialProb2, count0arr, 'LineWidth', 2)
title(['Effect of Radicals of one opinion (opinion 0) saturation at ' num2str(T) ' time steps'])
xlabel('Initial Density of opinion 0')
ylabel(['Final Density of opinion 0, at ' num2str(T) ' time steps'])
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)
legend('No radicals - Basic Model', [num2str(fractRadicals(2)*100) '% radicals'], [num2str(fractRadicals(3)*100) '% radicals'], [num2str(fractRadicals(4)*100) '% radicals'])
print('radical_single_op0_prob_var','-djpeg')

% plot grid to get final picture of 
figure
image(X)

set(gca,'XTick',[],'YTick',[])
title(['t = ', num2str(t)])
axis square