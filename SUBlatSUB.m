function [positivebasis,dimensions] = SUBlatSUB(A)
%SUBlatSUB(A) provides the vector sublattice
% or the lattice-subspace of a given finite
%collection of positive, linearly independent vectors
%of R^n
%A denotes the matrix whose columns are the given vectors
if any(any(A<0))~=0,
disp('ERROR: the initial matrix must have positive elements')
positivebasis=[];
dimensions=[];
return;
end
[N,M] = size(A);
if rank(A)~=M,
disp('ERROR: the given vectors are linearly dependent')
positivebasis=[];
dimensions=[];
return;
end
for i=1:N,
if norm(A(i,:),1)~=0,
Test(i,:) = 1/norm(A(i,:),1)*A(i,:);
end
end
matrix = Test;
[ii,jj] = find(matrix);
matrix1 = matrix(unique(ii),:);
u = unique(matrix1,'rows');
m = length(u(:,1));
if M == m,
disp('vector sublattice')
positivebasis = inv(u')*A';
dimensions = [M m N]';
else
m1 = rank(bsxfun(@minus,u,u(1,:)));
if m1<M,
utrans = bsxfun(@minus,u,u(1,:));
rot = orth(utrans');
uproj = utrans*rot;
tri = convhulln(uproj);
d = length(unique(tri(:)));
if d == M,
basis = inv(u(unique(tri(:)),:)')*A';
disp('lattice-subspace')
positivebasis = basis;
dimensions = [M m d N]';
else
    disp('not a lattice-subspace')
    dimensions = [M m d N]';
    positivebasis=[];
end
end
end