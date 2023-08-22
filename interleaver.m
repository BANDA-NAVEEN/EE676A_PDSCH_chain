function out = interleaver(data)

a=data;
p=reshape(a,2700,[])';%segmenting bits into row wise
q=reshape(p,1,[]);%writing the bits column wise 
out=q;
end