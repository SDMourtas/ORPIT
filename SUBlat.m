function [Sublattice, Positivebasis]=SUBlat(B)
%SUBlat (B) provides the vector sublattice generated by
%a given finite collection of positive, linearly
%independent vectors of Rn
%B denotes the matrix whose columns are the given vectors
[N, M]=size(B);
Id = eye(N);
for i = 1:N,
if norm(B(i,:), 1)~=0,
Test(i,:)=1/norm(B(i,:), 1)*B(i,:);
end
end
Matrix = Test;
[BB, m, n]=unique(Matrix, 'rows');
Index = 1:N;
S = rref(BB');
[I, J]=find(S);
Linearindep = accumarray(I, J, [rank(BB), 1], @min)';
mm = length(m);
nn = length(n);
Index1 = 1: mm;
Index2 = setdiff(Index1, Linearindep);
YY = sum(B, 2)';
TTT = setdiff(Index, m(Linearindep));
KK = Id(TTT,:);
TT = YY(1, TTT)';
T = diag(TT)*KK;
K = zeros(N);
K(TTT,:)=T;
Vec = zeros(mm-M, N);
if mm < nn,
for i = 1:length(Index2),
DD = strmatch(Index2(i), n, 'exact')';
R = length(DD);
if R >= 2,
Vector = sum(K (DD,:));
else
Vector = K(DD,:);
end
Vec(i,:)=Vector;
end
[a, b]=find(Vec);
Vectors = Vec(unique(a),:);
Sublattice=[B'; Vectors];
Positivebasis = SUBlatSUB(Sublattice');
else
KKK = unique(K, 'rows');
[II, JJ]=find(KKK);
Vectors = KKK(unique (II),:);
Sublattice=[B'; Vectors];
Positivebasis = SUBlatSUB(Sublattice');
end