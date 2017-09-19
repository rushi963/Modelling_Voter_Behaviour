% Author : Omkar Damle
% date : 7th April

%code to plot some data of random discussion groups simulation

clear all;
close all;
clc;

load('rg_d3')

plot(0.5:0.05:0.9,avgFDeven,0.5:0.05:0.9,avgFDodd,'Linewidth',2);
legend('Dominant Even sized groups','Dominant Odd sized groups','Location','northwest');
xlabel('Initial density');
ylabel({'Average Final density',' after 15 discussion cycles'});
title({'Comparison of even and odd sized discussion groups.','Bias in case of tie is with party 0'});
set(gca,'FontSize',20)
set(findall(gcf,'type','text'),'FontSize',20)

