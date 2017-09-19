%Author : Rushikesh Nalla
%Date : 4th April 2017
%Finding row and column of the matrix

function [r,c] = indexConv(index,n)

    if mod(index,n) == 0
        r=index/n;
        c=n;
    else    
        x=index/n;
        r = floor(x)+1;
        c = mod(index,n);
    end
end

