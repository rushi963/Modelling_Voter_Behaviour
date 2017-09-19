% modify majoiry to inclu mass media as a tie breaker

close all;

% init grid

% get dim x dim square grid
dim=10;


% populate grid with random 0's and 1's
mat= rand(dim,dim);
mat(mat>0.5)=1;
mat(mat<=0.5)=0;

% dimensions of matrix
[c,r]= size(mat);

% plot init conditions
im=imagesc((1:c)+0.5,(1:r)+0.5,mat);            %# Plot the image, each grid centres around points like (2.5, 1.5)
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
       'GridLineStyle','-','XGrid','on','YGrid','on');

figure

%%%%%%%%%%%%%%%%%%%%%%%

media_threshold=1;  % prob listen to media is 1- media_threshold
media_opinion=1;

% number of iterations
ite=1e4;

plot_count=0;
sub_pos=0;
for i=1:ite

concensus_count=0;

% apply peridic boudary conditions
latNS = [mat(end, :); mat; mat(1, :)]; % varcha khali, khalcha varti
extMat = [latNS(:, end) latNS latNS(:,1) ]; % periodic mat    

% get random x and y in the range [2 to n+1]
xrand= randi([2 dim+1],1,ite); % random x cordi 
yrand= randi([2 dim+1],1,ite); % random y cordi




% assign value of one of the neighbours randomly such that
% any assignment is equally likely.
% if rand<=0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i)-1);    
% elseif rand<=2*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i));
% elseif rand<=3*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i)+1);
% elseif rand<=4*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i),yrand(i)-1);
% elseif rand<=5*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i),yrand(i)+1);
% elseif rand<=6*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i)-1);
% elseif rand<=7*0.125
% extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i));
% else
% extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i)+1);
% end

% von neumann neighbour
consensus_count = extMat(xrand(i)-1,yrand(i)) + extMat(xrand(i)+1,yrand(i)) + extMat(xrand(i),yrand(i)-1) + extMat(xrand(i),yrand(i)+1); 

% if consensus take that opinion, otherwise take medias opinion
if consensus_count==4
    extMat(xrand(i),yrand(i))=1;
elseif consensus_count==0
    extMat(xrand(i),yrand(i))=0;
else
    if(rand>=media_threshold)
    extMat(xrand(i),yrand(i))=media_opinion;
    end
end

plot_count=plot_count+1;




if (plot_count==50)
    plot_count=0;
    sub_pos=sub_pos+1;
    subplot(3,2,sub_pos)
end





% strip the matrix of the boundary conditions
mat= extMat(2:(dim+1),2:(dim+1)); % strip off the boundaries for the picture
[r,c] = size(mat);                           %# Get the matrix size
im=imagesc((1:c)+0.5,(1:r)+0.5,mat);            %# Plot the image, each grid centres around points like (2.5, 1.5)
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
       'GridLineStyle','-','XGrid','on','YGrid','on');
  
M(i)=getframe; % plot new state 
   


end

%movie(M)
