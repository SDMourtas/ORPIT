function [Npb,Cprb] = mrsubspace(X)
% Determination of a basic set of marketed securities.
% Also, it is possible to determine the (normalized) positive
% basis(Npb) as well as the corresponding projection
% basis(Cprb).
if any(any(X < 0)) ~= 0
a = max(max(abs(X)));
B = a*ones(size(X)) - X;
if any(any(B < 0)) ~= 0
B = 2*a*ones(size(X)) - X;
end
else
B = X;
end
Matrix = zeros(size(B));
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
% Choose which vectors are linearly independent.
S = rref(Matrixnew');
[I,J] = find(S);
Linearindep = accumarray(I,J,[rank(Matrixnew),1],@min)';
M = length(B(1,:));
% Calculation of the vector sublattice F_1(X).
% A) If X=F_1(X).
if r == M
disp('X is a vector sublattice hence any option is replicated')
Npb=[];
Cprb=[];
return
end
% B) If X?=F_1(X).
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
% Determination of a positive basis(Pb) for F_1(X). First we
% calculate the new basic curve for F_1(X).
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
% Normalization of the positive basis(Npb).
Npb = diag(1./max(Pb,[ ],2))*Pb;
% Calculation of the projection basis(Prb).
Prb = Matrixnew(Linearindep,:)'\B';
% Calculation of the corresponding projection basis(Cprb).
Cprb = diag(1./max(Pb(1:size(Prb,1),:),[ ],2))*Prb;
% Maximal proper partitions - Maximal replicated subspaces.
% A) Check the trivial partition (i.e.,
%{1},{2},{3},{4},... ,{n}).
[N,M] = size(Cprb);
if ~any(any(Cprb~=1&Cprb~=0)) && abs(sum(Cprb)-ones(1,M))<10*eps,
MaximalReplicatedSubspace = Cprb
return
end
% B) If the trivial partition is not giving a Maximal Replicated
% Subspace
% then check all the other partitions. The first group of
% partitions, of the same
% order, that gives replicated subspace(s) are maximal proper
% partitions and the
% replicated subspaces are maximal replicated subspaces.
Cprbzeros = [Cprb;zeros(1,M)];
for k=1:N-1
c = SetPartition(N,N-k);
for i = 1:length(c)
Vector = zeros(N-k,M);
for j = 1:N-k
Indices = c{i,1}{1,j};
Vector(j,:) = sum([Cprbzeros(Indices,:);Cprbzeros(N+1,:)]);
end
Vector(Vector<10*eps)=0;
Vector(Vector<1+10*eps&Vector>1-10*eps)=1;
if ~any(any(Vector~=1&Vector~=0)) && all(abs(sum(Vector)-ones(1,M))<10*eps)
DispPartObj(c(i,1))
ReplicatedSubspace = Vector
end
end
end
%Trivial Replicated Subspace i.e Y=[1]
%ReplicatedSubspace = Vector