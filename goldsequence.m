function  out=goldsequence(p,q)
x1=p;
x2=q;
c=zeros(1,32400);
for i=1:length(c)
    c(1,i)=xor(x1(1,1),x2(1,1));%xoring the first bits of both sequences
    p=xor(x1(1,1),x1(1,4));%bit that to be added at last of first sequence
    x1=[x1(2:31),p];%shifing the bits of first sequence
    q=xor(x2(1,1),x2(1,2));
    r=xor(q,x2(1,3));
    t=xor(r,x2(1,4));%bit that to be added at last of second sequence
    x2=[x2(2:31),t];%shifing the bits of second sequence
end
out=c;
end