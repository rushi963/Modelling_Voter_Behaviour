%Author : Omkar Damle
%Date : 1st April 2017

%simulation of random group discussions

clear all;close all;clc;

tests=10;           %ensemble average
sumt=0;             %temp sum

avgFDodd = zeros(1,9);  %average final density - dominant odd group
avgFDeven = zeros(1,9); %average final density - dominant even group

tempp = 1;  %counter

for probVal=5:0.5:9             
    
    for xxx=1:2                 %xxx=1 -> odd, xxx=2 -> even

        sumtemp=0;
        for aa=1:tests
            
            n = 20;  %matrix size
            niter = 15; %no of discussion cycles
            density = zeros(niter+1);
            
            %%initiase the matrix with some random opinions
            grid = rand(n);
            initialDensity = probVal/10;       %density of 1s
            density(1) = initialDensity;
            for i=1:n
                for j=1:n
                    if grid(i,j)<initialDensity
                        grid(i,j) = 1;
                    else
                        grid(i,j) = 0;
                    end
                end
            end
            
            statusQuo = 0;      %required in case of a tie
            L = 6;      %maximum group size

            if xxx==1
                a = [0 0.3 0.6 0.05 0.05 0];
            else
                a = [0 0.3 0.3 0.3 0.1 0];
            end
                
            %%loop for cycle of discussions
            for i=1:niter
                
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
                    voteSum=0;
                    
                    dGroup = zeros(groupSize);
                    dGroup(1) = person;
                    
                    [r1,c1] = indexConv(person,n);
                    voteSum = voteSum + grid(r1,c1);
                    
                    people = setdiff(people,person);
                    
                    for x=2:groupSize
                        [r,c] = size(people);
                        u=randi(c);
                        dGroup(x) = people(u);
                        [r1,c1] = indexConv(dGroup(x),n);
                        voteSum = voteSum + grid(r1,c1);
                        people = setdiff(people,dGroup(x));
                    end
                    
                    frac = voteSum/groupSize;
                    groupVote = 0;
                    
                    if frac==0.5
                        groupVote = statusQuo;
                    elseif frac < 0.5
                        groupVote = 0;
                    else
                        groupVote = 1;
                    end
                    
                    for x=1:groupSize
                        [r1,c1] = indexConv(dGroup(x),n);
                        grid(r1,c1) = groupVote;
                    end
                    
                end
                
                density(i+1) = calculateDensity(grid);
                
            end
            
            if density(niter+1)>0.5
                sumt=sumt+1;
            end
            
            finalDensities(aa) = density(niter+1);
            sumtemp = sumtemp + density(niter+1);
        end
        %{
        nbins=20;
        hist(finalDensities,nbins);
        xlabel('Density after 10 discussion cycles');
        ylabel('frequencies');
        title({'Initial density=0.7','groupSizeProbabilities = [0 0.3 0.3 0.3 0.1 0]','bias=0'});
        set(gca,'FontSize',16)
        set(findall(gcf,'type','text'),'FontSize',16)
        
        sumt
        %}
        
        %{
plot(1:(niter+1),density)
xlabel('Number of discussion cycles');
ylabel('density of 1s');
str = num2str(statusQuo);
title({'variation of density with time',['status quo:',str]});
print('rg2','-dpng');
        %}
      
        if xxx == 1
            avgFDodd(1,tempp) = sumtemp/tests;
        else
            avgFDeven(1,tempp) = sumtemp/tests;            
        end
        
    end
    
    tempp=tempp+1;

end

%plotter.m will use the data calculated from this simulation to plot
%relevant graphs
