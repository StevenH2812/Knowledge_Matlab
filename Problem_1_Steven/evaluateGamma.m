function [ gamma ] = evaluateGamma( member,corners,x )
%EVALUATEGAMMA Summary of this function goes here
%   Detailed explanation goes here

den = 0;
for i = 1:length(corners)
    den = den + evaluateMembership(i,corners,x);
end

gamma = evaluateMembership(member,corners,x)/den;

end

