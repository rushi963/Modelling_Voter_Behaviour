% Author - Omkar Damle
% Date - 13th March 2017

%voter model simulation - non linear and linear voter models

clear all;
close all;
clc;


npoints = 100;
density = zeros(9,3,npoints);
T = 30000;                      %time steps

delta_t = T/npoints;
p_array = [0 0 0 1 1 1;     %majority
    0 0.2 0.4 0.6 0.8 1;    %linear
    0 0.5 0.5 0.5 0.5 1];   %threshold

for probVal=1:9
    
    for modelNo=1:3
        
        %    p = [0 0.5 0.5 0.5 0.5 1];      %probability function
        
        p = p_array(modelNo,:);
        n = 50;                         %n*n matrix
        
        c = 2;    % number of colors
        colormap(gray(c))              % use this with c=2!!!
        X=ceil(c*rand(n));              % initial state: random values: 1,2,...,c
        
        initialProb2 = probVal/10;
        [row,col] = size(X);
        
        for i=1:row
            for j=1:col
                u=rand;
                if u<initialProb2
                    X(i,j) = 2;
                else
                    X(i,j) = 1;
                end
                
            end
        end
        
        
        %    image(X)
        
        count = zeros(c);
        
        for i=1:row
            for j=1:col
                count(X(i,j)) = count(X(i,j))+1;
            end
        end
        
        str = sprintf('count(1)=%d and count(2)=%d',count(1),count(2));
        %   title(str);
        
        %   updateSteps=100;
        temp=1;
        
        axis square
        
        timeStep=0;
        for t=1:T
            
            u1=randi(n);
            u2=randi(n);   %uniformly at random in 2d
            
            %can be optimised for only one point
            Z(1,:,:)=X;
            Z(2,:,:)=X(:,[n 1:n-1]);           % states of neighbors left
            Z(3,:,:)=X(:,[2:n 1]);              % states of neighbors right
            Z(4,:,:)=X([n 1:n-1],:);           % states of neighbors above
            Z(5,:,:)=X([2:n 1],:);              % states of neighbors below
            
            sum = Z(1,u1,u2)+Z(2,u1,u2)+Z(3,u1,u2)+Z(4,u1,u2)+Z(5,u1,u2) - 5;
            
            u = rand;
            
            if u<p(sum+1)
                X(u1,u2) = 2;
            else
                X(u1,u2) = 1;
            end
            
            temp=temp+1;
            
            %        if temp<updateSteps
            if temp<delta_t
                continue;
            end
            
            timeStep=timeStep+1;
            temp=0;
            
            %        figure(1)
            %        image(X)
            
            
            count = zeros(c);
            
            for i=1:row
                for j=1:col
                    count(X(i,j)) = count(X(i,j))+1;
                end
            end
            
            %       str = sprintf('count(1)=%d, count(2)=%d, time steps=%d',count(1),count(2),t);
            
            %{
        title(str);
        
        
        set(gca,'XTick',[],'YTick',[])
        %	title(['t = ', num2str(t)])
        axis square
        pause(.001)
            %}
            density(probVal, modelNo,timeStep)=count(2)/(n*n);
            
        end
        
        
    end
    
end

%{
title({'Threshold Voter model(skewed)',str});
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)
print('ThresholdModelSkewed','-dpng')
%}

%plot(1:npoints, density(1,:),1:npoints, density(2,:),1:npoints, density(3,:));
%legend('majority','linear','threshold');


graph = zeros(9,3);

for i=1:9

    graph(i,:) = [density(i,1,npoints) density(i,2,npoints) density(i,3,npoints)];
end

bar(graph)
