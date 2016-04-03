function [ membership ] = evaluateMembership( member,corners,x)
%EVALUATEMEMBERSHIP This function evaluates the membership degree of a
%certain "x" location, given the specified membership functions in the
%interaction with main.m
%   This function works with corner points and interpolating between them.
%   If it is desired that the first or last membership function(s) stretch
%   to infinity, then the first or last corner should be specified as NaN
%   and the respective second or third corner should be -Inf or Inf
%   respectively
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

