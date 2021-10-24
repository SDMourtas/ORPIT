function [Pb_Completion,Pb_Minimal_ls] = srtest(X)
%***************************%
% General Information. %
%***************************%
% Synopsis:
% SR = srtest(X)
% [SR,Pb_Completion,Pb_Minimal_ls] = srtest(X)
%
% Input:
% X = the payoff matrix with the non-redundant
% security vectors x_1, x_2,...,x_n specified
% as columns.
%
% Output:
% SR = returns strongly resolving or strongly resolving with respect to
% the positive basis of F1(X) or stronlgy resolving
% with respect to the positive basis of a minimal lattice-subspace
% containing X.
%
% Pb_Completion = positive basis of F_1(X) which is a partition
% of the unit. The i column of the Pb_Completion
% matrix is the vector bi of the positive basis.
%
% Pb_Minimal_ls = positive basis of a minimal lattice-subspace
% containing X. The i column of the Pb_Minimal_ls
% matrix is the vector bi of the positive basis.
%
% Note that for the correct performance of the srtest function
% the presence of the MINlat function from [1], is needed.
%
% References:
% [1] V.N. Katsikis, I. Polyrakis, Computation of vector
% sublattices and minimal lattice-subspaces. Applications in finance.
% Applied Mathematics and Computation, 218 (2012), 6860-6873.
srtest0;
srtest1;
srtest2;
function srtest0 = srtest0
%***********************************%
% Strongly resolving market test. %
%***********************************%
[m,n] = size(X);
combos = combntns(1:m,n);
t = length(combos(:,1));
ranks = zeros(t,1);
for i = 1:t
Testmatrix = X(combos(i,:),:);
ranks(i) = rank(Testmatrix);
end
if any(ranks < n)
disp('Not strongly resolving market.')
return
else
disp('Strongly resolving.')
end
end
%*****************************************************%
% Strongly resolving market test with respect to the %
% positive basis of F1(X). %
%*****************************************************%
function srtest1 = srtest1
%******************************************************%
% Determination of a basic set of marketed securities. %
%******************************************************%
if any(any(X < 0)) ~= 0
a = max(max(abs(X)));
B= a*ones(size(X)) - X;
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
[~,m] = unique(Matrix,'rows','first');
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
[f,~] = find(Test_Pb);
Pb = Test_Pb(unique(f),:);
% Normalization of the positive basis (Npb).
Npb1 = diag(1./max(Pb,[ ],2))*Pb;
Npb = Npb1';
Npb(Npb < 10*eps) = 0;
Npb(Npb < 1+10*eps & Npb > 1-10*eps) = 1;
Pb_Completion = Npb;
%********************************************************%
% Expansion of the primitive securities in terms of the %
% positive basis (Npb) of F_1(X). %
%********************************************************%
X1 = Npb\B;
[mm,nn] = size(X1);
combos = combntns(1:mm,nn);
tt1 = length(combos(:,1));
ranks1 = zeros(tt1,1);
for i = 1:tt1
Testmatrix1 = X1(combos(i,:),:);
ranks1(i) = rank(Testmatrix1);
end
if any(ranks1 < nn)
disp('Not strongly resolving with respect to the pb of F1(X).')
return
else
disp('Strongly resolving with respect to the pb of F1(X).')
end
end
%*****************************************************%
% Strongly resolving market test with respect to the %
% positive basis of a minimal lattice-subspace %
% containing X. %
%*****************************************************%
function srtest2 = srtest2
if any(any(X < 0)) ~= 0
a = max(max(abs(X)));
B= a*ones(size(X)) - X;
if any(any(B < 0)) ~= 0
B = 2*a*ones(size(X)) - X;
end
else
B = X;
end
[~,Positivebasis] = MINlat(B);
Pb_Minimal_ls = Positivebasis';
X2 = Positivebasis'\B;
[mmm,nnn] = size(X2);
combos = combntns(1:mmm,nnn);
tt2 = length(combos(:,1));
ranks2 = zeros(tt2,1);
for i = 1:tt2
    Testmatrix2 = X2(combos(i,:),:);
ranks2(i) = rank(Testmatrix2);
end
if any(ranks2 < nnn)
disp('Not strongly resolving with respect to the pb of Y.')
return
else
disp('Strongly resolving with respect to the pb of Y.')
end
end
end