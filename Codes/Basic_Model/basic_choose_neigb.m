% here we simulate the steppings stone cellular automaton.
% we update each cell depending on a certain rule.

% it is important to note that this is an aborbing Markov chain
% with 2 absorbing states being all cells black and all white.
% thus given enough time these states will always be reached.
% thus after a long time we see one colour dominating the other.

% depending on the porportion of white and black cells in the beginning
% and since the transition to both states is equally likely, the cells 
% with majority eventually win. 
% the MC goes to one of the two absorbing states.

close all;

% init grid

% get dim x dim square grid
dim=10;

% populate grid with random 0's and 1's
mat= rand(dim,dim);
N_1=length(mat(mat>0.97)) 
N_0=length(mat(mat<=0.97)) % more likely to be black
mat(mat>0.95)=1;
mat(mat<=0.95)=0;

% dimensions of matrix
[c,r]= size(mat);

% plot init conditions


im=imagesc((1:c)+0.5,(1:r)+0.5,mat);            %# Plot the image, each grid centres around points like (2.5, 1.5)
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
       'GridLineStyle','-','XGrid','on','YGrid','on');

%figure

%%%%%%%%%%%%%%%%%%%%%%%


% number of iterations
ite=1e4;



for i=1:ite

% apply peridic boudary conditions
latNS = [mat(end, :); mat; mat(1, :)]; % varcha khali, khalcha varti
extMat = [latNS(:, end) latNS latNS(:,1) ]; % periodic mat    

% get random x and y in the range [2 to n+1]
xrand= randi([2 dim+1],1,ite); % random x cordi 
yrand= randi([2 dim+1],1,ite); % random y cordi




% assign value of one of the neighbours randomly such that
% any assignment is equally likely.
if rand<=0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i)-1);    
elseif rand<=2*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i));
elseif rand<=3*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i)-1,yrand(i)+1);
elseif rand<=4*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i),yrand(i)-1);
elseif rand<=5*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i),yrand(i)+1);
elseif rand<=6*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i)-1);
elseif rand<=7*0.125
extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i));
else
extMat(xrand(i),yrand(i))= extMat(xrand(i)+1,yrand(i)+1);
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
