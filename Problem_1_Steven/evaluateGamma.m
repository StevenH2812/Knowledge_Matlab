function [ gamma ] = evaluateGamma( member,corners,x )
%EVALUATEGAMMA This function is similar to evaluateMembership except that
%it divides by the total membership of all membership functions at a
%certain "x" location

den = 0;
for i = 1:length(corners)
    den = den + evaluateMembership(i,corners,x);
end

gamma = evaluateMembership(member,corners,x)/den;

end

