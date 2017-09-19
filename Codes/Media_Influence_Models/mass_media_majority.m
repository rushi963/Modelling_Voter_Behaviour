% modify majoiry to inclu mass media as a tie breaker
clear all;
close all;

% init grid

% get dim x dim square grid
dim=10;

% number of iterations
ite=1e3;
 
turns=1000;

N_1_turns= zeros(turns,1);

media_threshold=0;  % prob listen to media is 1- media_threshold
media_opinion=1;

density_arr= [0.1, 0.25, 0.5, 0.75, 0.9];
p_arr=[0.25, 0.5, 0.75, 1];
avg_N_1_wrt_density= zeros(length(density_arr),1);

for m=1:length(p_arr)

    media_threshold=p_arr(m);
    
    for k=1:length(density_arr)

        for j=1:turns

        % populate grid with random 0's and 1's
        mat= rand(dim,dim);
        mat(mat>( 1-density_arr(k) ) )=1; % curr 1 is mino
        mat( mat<=( 1-density_arr(k) ) )=0;

        n1= length(mat(mat==1));
        n0= dim*dim - n1;
        % dimensions of matrix
        [c,r]= size(mat);

        % plot init conditions
        % im=imagesc((1:c)+0.5,(1:r)+0.5,mat);            %# Plot the image, each grid centres around points like (2.5, 1.5)
        % colormap(gray);                              %# Use a gray colormap
        % axis equal                                   %# Make axes grid sizes equal
        % 
        % set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        %         'XLim',[1 c+1],'YLim',[1 r+1],...
        %        'GridLineStyle','-','XGrid','on','YGrid','on');
        % 
        % figure
        % 
        %%%%%%%%%%%%%%%%%%%%%%%




        plot_count=0;
        sub_pos=0;

        count_for_1=0;

        for i=1:ite



        % apply peridic boudary conditions
        latNS = [mat(end, :); mat; mat(1, :)]; % varcha khali, khalcha varti
        extMat = [latNS(:, end) latNS latNS(:,1) ]; % periodic mat    

        % get random x and y in the range [2 to n+1]
        xrand= randi([2 dim+1],1,ite); % random x cordi 
        yrand= randi([2 dim+1],1,ite); % random y cordi

        % von neumann neighbour, count_for_1 is an indicat rand var
        count_for_1 = extMat(xrand(i)-1,yrand(i)) + extMat(xrand(i)+1,yrand(i)) + extMat(xrand(i),yrand(i)-1) + extMat(xrand(i),yrand(i)+1); 

        count_for_0= 4 - count_for_1; 


        % if majority take that opinion, otherwise take medias opinion
        if count_for_1> count_for_0
            extMat(xrand(i),yrand(i))=1;
        elseif count_for_1 < count_for_0
            extMat(xrand(i),yrand(i))=0;
        else
            if(rand>=media_threshold)
            extMat(xrand(i),yrand(i))=media_opinion;
            end
        end


        % strip the matrix of the boundary conditions
        mat= extMat(2:(dim+1),2:(dim+1)); % strip off the boundaries for the picture
        % [r,c] = size(mat);                           %# Get the matrix size
        % im=imagesc((1:c)+0.5,(1:r)+0.5,mat);            %# Plot the image, each grid centres around points like (2.5, 1.5)
        % colormap(gray);                              %# Use a gray colormap
        % axis equal                                   %# Make axes grid sizes equal
        % 
        % set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        %         'XLim',[1 c+1],'YLim',[1 r+1],...
        %        'GridLineStyle','-','XGrid','on','YGrid','on');
        %   
        % M(i)=getframe; % plot new state 
        %    


        end

        %N_1_equi= length(find(mat(mat==1)));
        %N_0_equi= dim*dim- N_1_equi;

        N_1_turns(j)= length(find(mat(mat==1))); % equi for jth turn
        %movie(M)
        end

        avg_N_1_wrt_density(k)=mean(N_1_turns);
        %std_N_1=std(N_1_turns)
        %max_N_1=max(N_1_turns)
        %min_N_1=min(N_1_turns)

    end

    hold on

    plot(density_arr,avg_N_1_wrt_density);
    title('Equilibrium density of party with media support vs initial density of that party')
    xlabel('Initial density of party with media')
    ylabel('Equilibrium density of the said party ')

end