function rem=check_crc(Rx_Data,G)


D=Rx_Data;%data that is to be validaed for crc
%----------------------------------modulo 2 division ---------------------- -------------------------
db=D(1:length(G)); 
if db(1)==1
   rem=double(xor(db,G));
   rem=rem(2:end);
else
    rem=double(xor(db,zeros(1,length(G))));%operating the xor when first bit=0
    rem=rem(2:end);
end 
for i=(length(G)+1):(length(D))
    db=[rem,D(i)];
if db(1)==1%operating the xor when first bit=1
   rem=double(xor(db,G));
   rem=rem(2:end);
else
    rem=double(xor(db,zeros(1,length(G))));%operating the xor when first bit=0
    rem=rem(2:end);%final checksum that is to be check for errors or not 
end
end
end