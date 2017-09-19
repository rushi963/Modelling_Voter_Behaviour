%Author : Rushikesh Nalla
%Date : 4th April 2017
%simulation of tri party with random groups

clear all;
close all;  
clc;

n = 30;  %matrix size
niter = 20; %no of discussion cycles
densityA = zeros(1,niter+1);
densityB = zeros(1,niter+1);
densityC = zeros(1,niter+1);

%%initiase the matrix with some random opinions
alpha = 0; %prob of A winning on tie
beta = 0; %prob of B winning on tie
grid = rand(n);
initialDensityA = 0.55;
initialDensityB = 0.40;
initialDensityC = 1-(initialDensityA+initialDensityB);
densityA(1) = initialDensityA;
densityB(1) = initialDensityB;
densityC(1) = initialDensityC;

%Assigning initial densities
for i=1:n
    for j=1:n
        if grid(i,j)<initialDensityA
            grid(i,j) = 1;
        elseif grid(i,j)<initialDensityA+initialDensityB
            grid(i,j) = 2;
        else
            grid(i,j) = 3;
        end
    end
end

L = 3;      %group size
a = [0 0 1]; %probabilty mass function

%%loop for cycle of discussions
for i=1:niter
    
    total_count1 = 0;
    total_count2 = 0;
    total_count3 = 0;
    
    index=1;
    people=zeros(1,n*n);
    for j=1:n
        for k=1:n
            people(index) = index;
            index=index+1;
        end
    end
    
    %let the discussions begin
    
    while 1
        [r,c] = size(people);
        if c==0
            break;
        end
        
        person = people(randi(c));
        u=rand;
        sum=0;
        
        for x=1:L
            sum=sum+a(x);
            if u<sum
                break;
            end
        end
        
        groupSize = x;
        
        %handle the edge case - for example, groupSize is 4 but the number
        %of remaining people is 2.
        
        if length(people)<=L
            groupSize = length(people);
        end
        
        %now select groupSize-1 number of people from 'people' array
        %voteSum=0;
        count1 = 0; %number of people with opinion A
        count2 = 0; %number of people with opinion B
        count3 = 0; %number of people with opinion C
        
        dGroup = zeros(groupSize);
        dGroup(1) = person;
        
        [r1,c1] = indexConv(person,n);
        
        if grid(r1,c1) == 1
            count1 = count1 + 1;
        elseif grid(r1,c1) == 2
            count2 = count2 + 1;
        else
            count3 = count3 + 1;
        end
        people = setdiff(people,person); % removing people who have formed groups in the current discussion cycle
        
        for x=2:groupSize
            [r,c] = size(people);
            u=randi(c);
            dGroup(x) = people(u);
            [r1,c1] = indexConv(dGroup(x),n);
           
            if grid(r1,c1) == 1
                count1 = count1 + 1;
            elseif grid(r1,c1) == 2
                count2 = count2 + 1;
            else
                count3 = count3 + 1;
            end
            people = setdiff(people,dGroup(x));
        end
        
        %Checking majority
        if count1>count2 && count1>count3
            groupVote = 1;
        elseif count2>count1 && count2>count3
            groupVote = 2;
        elseif count3>count1 && count3>count2
            groupVote = 3;
        else
            u1 = rand();
            if u1<alpha
                groupVote = 1;
            elseif u1<alpha+beta
                groupVote = 2;
            else
                groupVote = 3;
            end
        end
        
        for x=1:groupSize
            [r1,c1] = indexConv(dGroup(x),n);
            grid(r1,c1) = groupVote;
        end
       
        total_count1 = total_count1 + count1;
        total_count2 = total_count2 + count2;
        total_count3 = total_count3 + count3;
    end
    
    %Calculating densities
    densityA(i+1) = total_count1/(total_count1+total_count2+total_count3);
    densityB(i+1) = total_count2/(total_count1+total_count2+total_count3);
    densityC(i+1) = total_count3/(total_count1+total_count2+total_count3);
end

%For Plotting    
plot(1:(niter+1),densityA,1:(niter+1),densityB,1:(niter+1),densityC,'Linewidth',2);
legend('Density of A','Density of B','Density of C');
xlabel('Number of discussion cycles');
ylabel('Density of different parties');
title('Initial Density A=0.55, B=0.40, C=0.05 Alpha=0 Beta=0');
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)
print('extra','-dpng');