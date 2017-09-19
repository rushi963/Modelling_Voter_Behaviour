function d = calculateDensity(grid)
%This function calculates density(proportion) of party 1's supporters in
%the grid

[r,c] = size(grid);
count=0;

for i=1:r
    for j=1:c
        count=count+grid(i,j);
    end
end

d = count/(r*c);

end

