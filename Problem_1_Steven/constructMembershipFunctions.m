function [ corners ] = constructMembershipFunctions( n,low,up )
%CONSTRUCTMEMBERSHIPFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here
dist = (up-low)/(n-1);
corners = {};
corners{1}.one = NaN;
corners{1}.two = -Inf;
corners{1}.three = low;
corners{1}.four = low+dist;
for i = 2:n-1
    corners{i}.one = corners{i-1}.three;
    corners{i}.two = corners{i}.one + dist;
    corners{i}.three = corners{i}.two;
    corners{i}.four = corners{i}.three+dist;
end
corners{n}.one = corners{n-1}.three;
corners{n}.two = corners{n-1}.four;
corners{n}.three = Inf;
corners{n}.four = NaN;

end

