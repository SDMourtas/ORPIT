function [theta_k]=mcpinsurance(a,floorvector,portfolio)
%a denotes a matrix whose columns are the given
%vectors x_1,x_2,...,x_N
%floorvector denotes the vector (k,k,...,k)
%portfolio denotes the theta vector
%Note that mcpinsurance requires the presence of the
%SUBlatSUB function
payoffvector=sum(a*diag(portfolio),2);
positivebasis=SUBlatSUB(a)';
if isempty(positivebasis)
    theta_k=[];
    return;
end
r=(positivebasis\payoffvector);
k=(positivebasis\floorvector');
w=max(r,k)';
sup=w*positivebasis';
theta_k=a\sup';
end