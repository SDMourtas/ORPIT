function [bb] = rabopb(X,x1,ab)
%The function rabopb() calculates the range of variable a of the interval  
%[a,b] of a linear span of a collection of vectors when a positive basis  
%exists by given the price of variable b. It can also calculate the range 
%of b instead of a. Furthermore, the function rabopb() gives as output the 
%range of variable a or b to which the price has been given as input in 
%order, the Wronski roots check, to be passed. If there is a pattern in the 
%relation between a and b then that pattern will be given, also, as output. 
%X denotes the linear span of a collection of vectors in terms of variable 
%t, x1 denotes the price of a or b of the interval [a,b] and ab specifies 
%what it was given in x1, a or b.
%
%INPUT      X,.... mx1 column vector
%           x1.... float number
%           ab.... 0 for x1=a or 1 for x1=b
%
%OUTPUT     bb.... mx2 matrix or 1x2 vector if m=1
syms t b a
bb=[];
%input arguments check
if ab~=0 && ab~=1
    disp('ERROR: The third input argument must be 0 or 1 for a or b, respectively.\n')
    return
end
if size(X,2)~=1
    disp('ERROR: A must be mx1 column vector\n')
    return
end
%Wronski roots check
warning('off','all');
n = length(X);
for i = 1:n
    d = diff(X,i-1);
    w(i,:) = d;
end
wronskiroots = unique(solve(det(w),t));
if  length(wronskiroots)==1 && wronskiroots==0
    disp('The Wronskian has no roots, hence the positivite basis does not exist.')
    return
end
z = sum(X);
beta = 1/z*X;
exc=[];
rra1=[];
rrb1=[];
wronski=[];
for i=1:numel(wronskiroots)
    if isreal(vpa(wronskiroots(i)))
    try
        subs(char(beta),t,vpa(wronskiroots(i)));
    catch
        exc=[exc vpa(wronskiroots(i))];
    end
    wronski=[wronski vpa(wronskiroots(i))];
    end
end
if isempty(wronski)
    disp('The Wronskian has no roots, hence he positivite basis does not exist.')
    return
end
%find the range of input x1 in order, the Wronski roots check, to passed 
rra1=max(wronski);
rrb1=min(wronski);
try
    V = [subs(beta,t,a),subs(beta,t,b)];
catch
    disp('The positivite basis does not exist')
    return
end
rra2=[];
rrb2=[];
I=[];
L=[];
dd = simplify(diff(beta,1));
ddd = vpa(solve(dd(1)));
for i = 2:length(X)
    d1 = vpa(solve(dd(i)));
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
if ~isempty(h)
    for i = 1:length(h)
        if ab==0
        if vpa(h(i))>=x1
        I(:,i) = subs(beta,t,h(i));
        end
        else
        if vpa(h(i))<=x1
        I(:,i) = subs(beta,t,h(i));
        end
        end
    end
rra2=max(h);
rrb2=min(h);
end
end
if ~isreal(z)
    y1 = vpa(unique(solve(z)));
    d2=[];
    if ab==0
    for j = 1:length(y1)
        if isreal(vpa(y1(j,1))) && vpa(y1(j,1))>=x1
            d2(j,:) = y1(j,1);
        end
    end
    else
    for j = 1:length(y1)
        if isreal(vpa(y1(j,1))) && vpa(y1(j,1))<=x1
            d2(j,:) = y1(j,1);
        end
    end
    end
    if isempty(d2) && isempty(I)
        disp('Positive basis does not exist')
    return
    end
    rra2=max(d2);
    rrb2=min(d2);
    kk=unique(d2);
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
    q1=1:numel(kk);
    q1=setdiff(q1,q2);
    L=L(:,q1);
end
if ~isempty(rra2) 
    rra=min(vpa(rra1),vpa(rra2));
else
    rra=vpa(rra1);
end
if ~isempty(rrb2) 
    rrb=max(vpa(rrb1),vpa(rrb2));
else
    rrb=vpa(rrb1);
end
exc1=[];
if ~isempty(exc)
    if ab==0
    if rra>min(vpa(real(exc)))
        exc1=min(vpa(real(exc)));
        fprintf('Wronski roots check needs a: (-oo,%s)U(%s,%s)\n',exc1,exc1,vpa(real(rra)))
    else
        fprintf('Wronski roots check needs a: (-oo,%s)\n',vpa(real(rra)))
    end
    else
    if rrb<max(vpa(real(exc)))
        exc1=max(vpa(real(exc)));
        fprintf('Wronski roots check needs b: (%s,%s)U(%s,+oo)\n',vpa(real(rrb)),exc1,exc1)
    else
        fprintf('Wronski roots check needs b: (%s,+oo)\n',vpa(real(rrb)))
    end
    end
else
    if ab==0
        fprintf('Wronski roots check needs a: (-oo,%s)\n',vpa(real(rra)))
    else
        fprintf('Wronski roots check needs b: (%s,+oo)\n',vpa(real(rrb)))
    end
end
if ab==0
if  ~isempty(exc1) && x1==exc1 && x1<rra
    fprintf('The input value of a does not belong in the range: (-oo,%s)U(%s,%s)\n',vpa(real(exc1)),vpa(real(exc1)),vpa(real(rra)))
    return
end
if x1>=rra
    fprintf('The input value of a does not belong in the range: (-oo,%s)\n',vpa(real(rra)))
    return
end
else
if  ~isempty(exc1) && x1==exc1 && x1>rrb
    fprintf('The input value of b does not belong in the range: (%s,%s)U(%s,+oo)\n',vpa(real(rrb)),vpa(real(exc1)),vpa(real(exc1)))
    return
end
if x1<=rrb
    fprintf('The input value of b does not belong in the range: (%s,+oo)\n',vpa(real(rrb)))
    return
end
end
if isempty(L) && isempty(I)
    disp('Positive basis does not exist because iotabeta and limit set are empty')
    return
end
K=[V I L];
if size(K,2)<size(K,1)   
    disp('Positive basis does not exist')
    return
else
    q = combntns(1:size(K,2),size(K,1));
end
h1=3:2+size(I,2);  %location of I inside q
q11=3+size(I,2):2+size(I,2)+size(L,2);  %location of L inside q
bbtt=[];
for j = 1:size(q,1)
k2 = q(j,:);
K1 = K(:,k2);
%calculates the range of a or b and checks if a positive basis exists
if det(K1)==0
    break
end
h11=intersect(h1,q(j,:));
q111=intersect(q11,q(j,:));
w = (inv(K1)*beta);
bbp=[];
if ab==0
    www=subs(w,a,x1);
else
    www=subs(w,b,x1);
end
for qi=1:numel(w)
    p=unique(solve(www(qi),t));
    hr=[];
    bbp1=[];
    if numel(p)>=4 && p(1)==x1 && (p(2)==a || p(2)==b)
    u1=[];
    for tr=setdiff(1:numel(p)+2,2)
        if tr<=numel(p)
            u1=subs(www(qi),t,(p(tr)+p(2))/2);
        elseif tr==numel(p)+1
            u1=subs(www(qi),t,(p(tr-1)+p(tr-2))/2);
        else
            u1=subs(www(qi),t,(p(tr-2)+p(tr-3)));
        end
        try
        try
        u1=vpa(solve(u1));
        catch
        u1=vpasolve(u1);
        end
        catch
        u1=[];
        end
    if ab==0
        for jr=1:numel(u1)
        if real(u1(jr))>=x1 && real(u1(jr))>=rrb
        hr=[hr;real(u1(jr))];
        end
        end
    else
        for jr=1:numel(u1)
        if real(u1(jr))<=x1 && real(u1(jr))<=rra
        hr=[hr;real(u1(jr))];
        end
        end
    end
    end
        bbp1=[bbp1;hr];
    elseif numel(p)==3 && p(1)==x1 && (p(2)==a || p(2)==b)
        pp=unique(solve(w(qi),t));
        do=[];
        uo=[];
        if ab==0
        do=solve(pp(3)-pp(1),b);
        uo=solve(pp(3)-pp(2),b);
        else
        do=solve(pp(3)-pp(1),a);
        uo=solve(pp(3)-pp(2),a);
        end
    if isempty(do) || isempty(uo)
        break
    end
    d1=[];
    u1=[];
    for ry=1:length(do)
        if ~isreal(do(ry))
            d1=[d1;do(ry)];
        end
    end
    for ry=1:length(uo)
        if ~isreal(uo(ry))
            u1=[u1;uo(ry)];
        end
    end
    a2=subs(d1,x1);
    b2=subs(u1,x1);
    bbp1=[bbp1;real(a2);real(b2)];
    end
bbp=[bbp;bbp1];
bbp=vpa(uniquetol(double(bbp),1.0000e-20));
end
if ~isempty(bbp)
    bii=[];
    if ab==0
        if rrb>x1
        bn=[rrb;bbp;bbp(length(bbp))+1];
        else
        bn=[x1;bbp;bbp(length(bbp))+1];
        end
    else
        if rra<x1
        bn=[bbp(1)-1;bbp;rra];
        else
        bn=[bbp(1)-1;bbp;x1];
        end
        x2=x1;
    end
bn=unique(bn);
xx1=x1;
for fg=1:numel(bn)-1
    if ab==0
    x2=double((bn(fg)+bn(fg+1))/2);
    else
    xx1=double((bn(fg)+bn(fg+1))/2);
    end
    c5=0;  %checks if the final outcome of the eq into the [-inf,+inf] has...
       %at least one interval in which the intersection with [a,b] is empty
    c9=0;  %checks if the final outcome of the eq into the [-inf,+inf] is NULL
for r=1:numel(w)
k=[];
p=[];
    if ab==0
    wa=subs(www,b,x2);
    else
    wa=subs(www,a,xx1);
    end
sumofxi = simplify(sum(wa));
if sumofxi~=1
    disp('Positive basis does not exist')
    break
end
k=unique(solve(wa(r)));
if ~isempty(k)
    for jt = 1:numel(k)
        if isreal(k(jt))
            p=[p;k(jt)];
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
    d=subs(wa(r),p(1)-1);
catch
    d=0;
    c6=1;
end
try        
    u=subs(wa(r),p(numel(p))+1);
catch
    u=0;
    c8=1;
end
if vpa(d)<0
    if vpa(p(1))<=xx1
        c1=1;
    end
end
for i=1:numel(p)-1
    try        
        m=subs(wa(r),(p(i)+p(i+1))/2);
    catch
        m=0;
        c7=c7+1;
    end
    if vpa(m)<0
        c2=c2+1;
        if vpa(p(i))>=x2 || vpa(p(i+1))<=xx1
        c3=c3+1;
        end
    end
end
if c2~=c3
    break
end
if vpa(u)<0
    if vpa(p(numel(p)))>=x2
    c4=1;
    end
end
if c6==1 && c7==numel(wa) && c8==1
    c9=c9+1;    
end
if c1==1 || c2~=0 || c4==1 
    c5=c5+1;
end
end
if c9==numel(wa)
    bi=0;
elseif c5==numel(wa)
    bi=1;
else
    bi=0;
end
bii(fg)=bi;
end
bt=[];
for er=1:length(bii)
if bii(er)==1
    bt1=bn(er);
    bt2=bn(er+1);
    bt=[bt;bt1 bt2];
end
end
if ~isempty(bt)
    if size(bt,1)~=1       %check for consecutive spaces
    for er=1:length(bt)-1
        if bt(er,2)==bt(er+1,1)
            bt(er+1,1)=bt(er,1);
            bt(er,1)=0;
            bt(er,2)=0;
        end
    end
    bb1=[];
    bb2=[];
    for er=1:size(bt,1)       %join the consecutive spaces
        if bt(er,1)~=bt(er,2)
            bb1=[bb1;bt(er,1)];
            bb2=[bb2;bt(er,2)];
        end
    end
    else
        bb1=bt(1);
        bb2=bt(2);
    end
    h4=[];
    if ~isempty(I) && ~isempty(h11)  %find the roots of I are inside K
        h3=h11-2;
    for jj=1:numel(h3)
        h4=[h4;h(h3(jj))];
    end
    end
    q4=[];
    if ~isempty(L) && ~isempty(q111)  %find the roots of L are inside K
        q3=q111-2-size(I,2);
        for jj=1:numel(q3)
            q4=[q4;kk(q1(q3(jj)))];
        end
    end
    for rt=1:numel(bb1)       %complete the restriction of I and L
    if ~isempty(h4) && isempty(q4)
    if ab==0
    if bb1(rt)>=max(h4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb1(rt)<max(h4) && max(h4)<=bb2(rt)
        bbtt=[bbtt;max(h4) bb2(rt)];
    end
    else
    if bb2(rt)<=min(h4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb2(rt)>min(h4) && min(h4)>=bb1(rt)
        bbtt=[bbtt;bb1(rt) min(h4)];
    end
    end
    elseif ~isempty(q4) && isempty(h4)
    if ab==0
    if bb1(rt)>=max(q4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb1(rt)<max(q4) && max(q4)<=bb2(rt)
        bbtt=[bbtt;max(q4) bb2(rt)];
    end
    else
    if bb2(rt)<=min(q4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb2(rt)>min(q4) && min(q4)>=bb1(rt)
        bbtt=[bbtt;bb1(rt) min(q4)];
    end
    end
    elseif ~isempty(h4) && ~isempty(q4)
    if ab==0
    if bb1(rt)>=max(q4,h4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb1(rt)<max(q4,h4) && max(q4,h4)<=bb2(rt)
        bbtt=[bbtt;max(q4,h4) bb2(rt)];
    end
    else
    if bb2(rt)<=min(q4,h4)
        bbtt=[bbtt;bb1(rt) bb2(rt)];
    elseif bb2(rt)>min(q4,h4) && min(q4,h4)>=bb1(rt)
        bbtt=[bbtt;bb1(rt) min(q4,h4)];
    end
    end
    else
    bbtt=[bbtt;bb1(rt) bb2(rt)];
    end
    end
end
end
end
if isempty(bbtt)
    if ab==0
    disp('Positive basis does not exists for that a input.')
    else
    disp('Positive basis does not exists for that b input.')
    end
    return
else
if size(bbtt,1)~=1       %check for consecutive spaces
    for er=1:length(bii)-1
        if bbtt(er,2)==bbtt(er+1,1)
            bbtt(er+1,1)=bbtt(er,1);
            bbtt(er,1)=0;
            bbtt(er,2)=0;
        end
    end
    bb1=[];
    bb2=[];
    for er=1:size(bbtt,1)       %join the consecutive spaces
        if bbtt(er,1)~=bbtt(er,2)
            bb1=[bb1;bbtt(er,1)];
            bb2=[bb2;bbtt(er,2)];
            if ab==0
            if ~isempty(exc) && bbtt(er,1)<max(vpa(real(exc))) && bbtt(er,2)>max(vpa(real(exc)))
            ort=max(vpa(real(exc)));
            fprintf('The range of b for the input a=%d is: [%s,%s)U(%s,%s]\n',x1,bbtt(er,1),ort,ort,bbtt(er,2))
            else
            fprintf('The range of b for the input a=%d is: [%s,%s]\n',x1,bbtt(er,1),bbtt(er,2))
            end
            else
            if ~isempty(exc) && bbtt(er,1)<min(vpa(real(exc))) && bbtt(er,2)>min(vpa(real(exc)))
            ort=min(vpa(real(exc)));
            fprintf('The range of a for the input b=%d is: [%s,%s)U(%s,%s]\n',x1,bbtt(er,1),ort,ort,bbtt(er,2))
            else
            fprintf('The range of a for the input b=%d is: [%s,%s]\n',x1,bbtt(er,1),bbtt(er,2))
            end
            end
        end
    end
    bb=[bb1 bb2];
    else
    bb=bbtt;
    if ab==0
        if ~isempty(exc) && bb(1)<max(vpa(real(exc))) && bb(2)>max(vpa(real(exc)))
        ort=max(vpa(real(exc)));
        fprintf('Positive basis exists for b: [%s,%s)U(%s,%s]\n',bb(1),ort,ort,bb(2))
        else
        fprintf('Positive basis exists for b: [%s,%s]\n',bb(1),bb(2))
        end
        else
        if ~isempty(exc) && bb(1)<min(vpa(real(exc))) && bb(2)>min(vpa(real(exc)))
        ort=min(vpa(real(exc)));
        fprintf('Positive basis exists for a: [%s,%s)U(%s,%s]\n',bb(1),ort,ort,bb(2))
        else
        fprintf('Positive basis exists for a: [%s,%s]\n',bb(1),bb(2))
        end
    end
end
if isempty(L) && size(bb,1)==1
    if bb(1)==a2 && bb(2)==b2
        if ab==0
        fprintf('The range of b, for every a in Wronski range of a, is: [ %s , %s ]\n',d1,u1)
        else
        fprintf('The range of a, for every b in Wronski range of b, is: [ %s , %s ]\n',d1,u1)   
        end
    end
end
end
end