function [Reprices,Npb] = reprices(X,x)
%***************************%
% General Information. %
%***************************%
% Synopsis:
% Reprices = reprices(X,x)
% [Reprices,Npb] = reprices(X,x)
% Input:
% X = the payoff matrix with the non-redundant
% security vectors x_1, x_2,...,x_n specified
% as columns.
% x = a given nonconstant portfolio of X.
% Output:
% Reprices = is a cell array containing the
% replicated exercise prices of x.
% Npb = positive basis of F_1(X) which is a partition
% of the unit. The i column of the Npb matrix is
% the vector bi of the positive basis.
%******************************************************%
% Determination of a basic set of marketed securities. %
%******************************************************%
if any(any(X < 0)) ~= 0
a = max(max(abs(X)));
B = a*ones(size(X)) -X;
if any(any(B < 0)) ~= 0
B = 2*a*ones(size(X)) - X;
end
else
B = X;
end
Matrix = zeros(size(B));
%**********************************%
% Range of the basic curve. %
%**********************************%
% Determination of the basic curve.
N = length(B(:,1));
for i = 1:N,
if norm(B(i,:),1) ~= 0,
Matrix(i,:) = 1/norm(B(i,:),1)*B(i,:);
end
end
% Find the unique elements of the range of the basic curve.
[Unique,m] = unique(Matrix,'rows','first');
Sort_m = sort(m);
Matrixnew = Matrix(Sort_m,:);
r = length(m);
%**********************************************%
% Calculation of the vector sublattice F_1(X). %
%**********************************************%
% Choose which vectors are linearly independent.
S = rref(Matrixnew');
[I,J] = find(S);
Linearindep = accumarray(I,J,[rank(Matrixnew),1],@min)';
M = length(B(1,:));
% A) If X=F_1(X).
if r == M
disp('X is a vector sublattice hence any option is replicated')
end
% B) If X~=F_1(X).
Index1 = 1:r;
Index2 = setdiff(Index1,Linearindep);
Index = 1:N;
YY = sum(B,2)';
TTT = setdiff(Index,Linearindep);
Id = eye(N);
KK = Id(TTT,:);
TT = YY(1,TTT)';
T = diag(TT)*KK;
K = zeros(N);
K(TTT,:) = T;
Vec = zeros(r-M,N);
DDD = cell(r-M,1);
for i = 1:length(Index2)
DD = strmatch(Matrixnew(Index2(i),:),Matrix,'exact');
R = length(DD);
if R >= 2,
Vector = sum(K(DD,:));
else
Vector = K(DD,:);
end
DDD{i,:} = DD;
Vec(i,:) = Vector;
end
Sublattice = [B Vec'];
%****************************************************%
% Determination of a positive basis for F_1(X) which %
% is a partition of the unit. %
%****************************************************%
% Calculate the new basic curve for F_1(X).
Matrixnew2 = zeros(size(Sublattice));
for i = 1:N,
if norm(Sublattice(i,:),1) ~= 0,
Matrixnew2(i,:) = 1/norm(Sublattice(i,:),1)*Sublattice(i,:);
end
end
u = Matrixnew2([Sort_m(Linearindep)' cell2mat(DDD)'],:);
Test_Pb = u'\Sublattice';
[f,ff] = find(Test_Pb);
Pb = Test_Pb(unique(f),:);
% Normalization of the positive basis (Npb).
Npb1 = diag(1./max(Pb,[ ],2))*Pb;
Npb = Npb1';
Npb(Npb < 10*eps) = 0;
Npb(Npb < 1+10*eps & Npb > 1-10*eps) = 1;
%************************************************************%
% Determination of the row leader elements and the interval %
% of replicated exercise prices. %
%************************************************************%
esscoef = unique(x);
mu = length(esscoef);
if mu <= 3
Reprices = [];
return
end
[i,j] = find(Npb');
Z = accumarray(i,j,[r,1],@min)';
L = x(Z);
disp('The interval of nontrivial exercise prices of x:');
disp([esscoef(1,1),esscoef(end,1)]);
%************************************************************%
% Expansion of the primitive securities in terms of the %
% positive basis (Npb) of F_1(X). Construct the matrices Wr, %
% Jr and Zr. Solve the corresponding systems. %
%************************************************************%
X1 = Npb\X;
R_Sol = length(X(1,:))+1;
Solution = zeros(R_Sol,mu-3);
Reprices = cell(1,mu-3);
for r = 1:mu-3
K = L;
K(K < esscoef(r+2)) = 0;
Wr = K;
K(K~=0) = 1;
Jr = K;
Zr = [X1 Jr];
Solution(:,r) = Zr\Wr;
%*********************************************************%
% Decide which of the resulting solutions are replicated %
% exercise prices. %
%*********************************************************%
if Solution(R_Sol,r) >= esscoef(r+1,1) && ...
Solution(R_Sol,r) < esscoef(r+2,1)
Reprices{1,r} = Solution(R_Sol,r);
else
Reprices{1,r} = '-';
end
end