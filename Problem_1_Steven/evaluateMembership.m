function [ membership ] = evaluateMembership( member,corners,x)
%EVALUATEMEMBERSHIP Summary of this function goes here
%   Detailed explanation goes here
membership = 0;
if x<corners{member}.one
    membership = 0;
elseif x>=corners{member}.one && x<corners{member}.two
    slope = 1/(corners{member}.two-corners{member}.one);
    membership = (x-corners{member}.one)*slope;
elseif x>=corners{member}.two && x<corners{member}.three
    membership = 1;
elseif x>=corners{member}.three && x<corners{member}.four
    slope = 1/(corners{member}.four-corners{member}.three);
    membership = 1-(x-corners{member}.three)*slope;
else
    membership = 0;
end

end

