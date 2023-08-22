function [Tx_data,crc]=gen_crc(Data,G)


n=length(G)-1;%no of zeros appended at the last
D=[Data,zeros(1,n)];%appened data with zeros of length=degree of generator polynomial

db=D(1:length(G));%taking data bits of length  generator polynomial
%----------------------------------modulo 2 division ---------------------- -------------------------
if db(1)==1%operating the xor when first bit=1
   rem=double(xor(db,G));
   rem=rem(2:end);
else
    rem=double(xor(db,zeros(1,length(G))));%operating the xor when first bit=0
    rem=rem(2:end);
end 
%similar ooperation is performed to like division operaton
for i=(length(G)+1):(length(D))
    db=[rem,D(i)];
if db(1)==1%operating the xor when first bit=1
   rem=double(xor(db,G));
   rem=rem(2:end);
else
    rem=double(xor(db,zeros(1,length(G))));%operating the xor when first bit=0
    rem=rem(2:end);
end
end

crc=rem;%checksum bits which is to be appended
Tx_data=[Data,crc];%tramsmitted data of tb + tb_crc

end