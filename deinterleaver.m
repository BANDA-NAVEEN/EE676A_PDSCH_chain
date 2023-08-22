function out = deinterleaver(data)

a=data;
r=reshape(a,4,[]);%reading the bits into column wise
h=reshape(r,[],2700)';
y=reshape(h,1,[]);%writing the bits into row wise 
out=y;
end