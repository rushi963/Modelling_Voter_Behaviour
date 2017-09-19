function [r,c] = indexConv(index,n)
% convert from 1-d index to 2-d index
    if mod(index,n) == 0
        r=index/n;
        c=n;
    else    
        x=index/n;
        r = floor(x)+1;
        c = mod(index,n);
    end
end

