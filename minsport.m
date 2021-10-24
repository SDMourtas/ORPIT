function [pb,mip] = minsport(X,x1,x2,theta,phi)
%The function minsport() calculates the minimum insured portfolio and the 
%positive basis. A denotes the portfolio in terms of variable t, [x,y]
%denotes the time range, pb denote the positive basis and mip denotes the
%minimum-cost insured portfolio.
%
%INPUT      X,theta,phi.... mx1 column vector
%           x1,x2.... float number
%
%OUTPUT     mip,pb.... mx1 column vector
syms t
pb=[];
mip=[];
%input arguments check
if size(X,2)~=1
    disp('ERROR: A must be mx1 column vector\n')
    return
end
if size(theta,2)~=size(X,1) && size(theta,1)~=1
    disp('ERROR: wrong input arguments\n')
    return
elseif size(theta,1)==size(X,1)
    theta=theta';
end
if size(phi,2)~=size(X,1) && size(phi,1)~=1
    disp('ERROR: wrong input arguments\n')
    return
elseif size(phi,1)==size(X,1)
    phi=phi';
end

%Wronski roots check
warning('off','all');
if x1 >= x2
    disp('ERROR: x1 must be <= x2\n')
    return
end
n = length(X);
for i = 1:n
    df = diff(X,i-1);
    w(i,:) = df;
end
wronskiroots = unique(solve(det(w),t));
if  length(wronskiroots)==1 && wronskiroots==0
    disp('The Wronskian has no root in [x1,x2], so the positivite basis does not exist')
    return
end
wr1 = 0;
for i = 1:length(wronskiroots)
if vpa(wronskiroots(i)) <= x2 && vpa(wronskiroots(i)) >= x1
    disp('The Wronskian has at least one root in [a,b]')
    break
else
    wr1 = wr1+1;
end
end
if wr1==length(wronskiroots)
    disp('The Wronskian has no root in [x1,x2], so the positivite basis does not exist')
    return
end
%find a possible positive basis
z = sum(X);
beta = 1/z*X;
try
    V = [subs(beta,t,x1),subs(beta,t,x2)];
catch
    disp('The positivite basis does not exist')
    return
end
I=[];
L=[];
dd = simplify(diff(beta,1));
ddd = solve(dd(1));
for i = 2:length(X)
    d1 = solve(dd(i));
    ww = intersect(ddd,d1);
    if isempty(ww)
        disp('iotabeta is empty')
        ddd=[];
        break
    else
       ddd = ww;
    end
end
if ~isempty(ddd)
if isreal(z)
    g = [ ];
else
    y = solve(z);
    for j = 1:length(y)
        if real(y(j)) == y(j)
        g(j) = y(j);
        end
    end
end
try
h = setdiff(ddd,g);
catch
h=[];
end
if isempty(h)
    disp('iotabeta is empty')
else
    for i = 1:length(h)
        if double(h(i)) <= x2 && double(h(i)) >= x1
        I(:,i) = subs(beta,t,h(i));
        end
    end
end
end
if ~isreal(z)
    y1 = unique(solve(z));
    d2=[];
    for j = 1:length(y1)
        if isreal(vpa(y1(j,1))) && vpa(y1(j,1))>= x1 && vpa(y1(j,1))<= x2 
            d2(j,:) = y1(j,1);
        end
    end
    if isempty(d2) && isempty(I)
        disp('Positive basis does not exist')
    return
    end
    kk = unique(d2);
    q2=[];
    for j = 1:numel(kk)
        L(:,j) = limit(beta,t,kk(j));
        for i=1:size(L,1)
        if isnan(L(i,j))
            q2=[q2 j];
            break
        end
        end
    end
    q1=(1:1:numel(kk));
    q1=setdiff(q1,q2);
    L=L(:,q1);
end
if isempty(L) && isempty(I)
    disp('Positive basis does not exist')
    return
end
K=[V I L];
if size(K,2)<size(K,1)   
    disp('Positive basis does not exist')
    return
else
    q = combntns(1:size(K,2),size(K,1));
end
for j = 1:size(q,1)
s2=[];
k2 = q(j,:);
s1 = K(:,k2);
%check if the positive basis exists
if det(s1)==0
    disp('Positive basis does not exist');
    break
end
w = (inv(s1)*beta);
try
    sumofxi = simplify(sum(w));
catch
    sumofxi = 0;
end
if sumofxi~=1
    disp('Positive basis does not exist')
elseif sumofxi==1
c5=0;  %checks if the final outcome of the eq into the [-inf,+inf] has...
       %at least one interval in which the intersection with [a,b] is empty
c9=0;  %checks if the final outcome of the eq into the [-inf,+inf] is NULL
for r=1:numel(w)
k=[];
p=[];
k=unique(solve(w(r)));
if ~isempty(k)
    for jr = 1:numel(k)
        if isreal(k(jr))
            p=[p;k(jr)];
        end
    end
end
c1=0;  %checks if the intersection of [-inf,root(1)] with [a,b] is empty
c2=0;  %checks if each outcome of the eq into the [root(1),root(2)],...
       %...,[root(n-1),root(n)] is NULL
c3=0;  %checks if the intersection of [root(1),root(2)],...
       %...,[root(n-1),root(n)] with [a,b] are empty
c4=0;  %checks if the intersection of [root(n),+inf] with [a,b] is empty
c6=0;  %checks if the outcome of the eq into the [-inf,root(1)] is NULL
c7=0;  %checks if the whole outcome of the eq into the [root(1),root(2)],..
       %...,[root(n-1),root(n)] is NULL
c8=0;  %checks if the outcome of the eq into the [root(n),+inf] is NULL
try        
    d=subs(w(r),p(1)-1);
catch
    d=0;
    c6=1;
end
try        
    u=subs(w(r),p(numel(p))+1);
catch
    u=0;
    c8=1;
end
if vpa(d)<0
    if vpa(p(1))<=x1
        fprintf('realrange (-oo,%s)\n',vpa(p(1)))
        c1=1;
    end
end
for i=1:numel(p)-1
    try        
        m=subs(w(r),(p(i)+p(i+1))/2);
    catch
        m=0;
        c7=c7+1;
    end
    if vpa(m)<0
        c2=c2+1;
        if vpa(p(i))>=x2 || vpa(p(i+1))<=x1
        fprintf('realrange (%s,%s)\n',vpa(p(i+1)),vpa(p(i)))
        c3=c3+1;
        end
    end
end
if c2~=c3
    disp('this is not an extreme subset of C')
    r=numel(w);
    break
end
if vpa(u)<0
    if vpa(p(numel(p)))>=x2
    fprintf('realrange (%s,+oo)\n',vpa(p(numel(p))))
    c4=1;
    end
end
if c6==1 && c7==numel(w) && c8==1
    c9=c9+1;    
end
if c1==1 || c2~=0 || c4==1 
    c5=c5+1;
end
end
if c9==numel(w)
    disp('this is not an extreme subset of C')
elseif c5==numel(w)
    if size(s1,1)==size(s1,2)
    s2=simplify(inv(s1)*X);
    else
    s2=simplify(inv(s1'*s1)*s1'*X);
    end
else
    disp('this is not an extreme subset of C')
end
if ~isempty(s2)
    pb=s2;
%calculation of the minimum-cost insured portfolio
    m=0;
for i=1:length(pb)
   if m<numel(coeffs(pb(i),'All'))
       m=numel(coeffs(pb(i),'All'));
   end
end
S=[];
for i=1:length(pb)
    r=0;
    kl=coeffs(pb(i),'All')';
    if numel(kl)==m
        for jt=1:numel(kl)
        S(jt,i)=kl(jt);
        end
    else
        r=m-numel(kl);
        for jt=1:r
        kl=[0;kl];
        end
        for jt=1:numel(kl)
        S(jt,i)=kl(jt);
        end
    end
end
Ptheta=sym2poly(theta*X);
Pphi=[0 sym2poly(phi*X)];
try
    Pthetanew=S\Ptheta';
    Pphinew=S\Pphi';
catch
    disp('the minimum-cost insured portfolio cannot be calculated')
    break
end
disp('the minimum-cost insured portfolio at every arbitrage price is:')
mip=max(Pthetanew,Pphinew);
break
end
end
end
if isempty(pb)
    disp('Positive basis does not exist')
    return
end
end