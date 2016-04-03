function [ corners ] = constructMembershipFunctions( n,low,up )
%CONSTRUCTMEMBERSHIPFUNCTIONS This function is responsible for the
%automatic generation of membership functions within a certain upper and
%lower bound. This function is called when the user specifies that it wants
%to have the membership functions automatically generated

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

