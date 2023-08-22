function out = descrambler(data1,data2,data3)
A_4=data1;
B_4=data2;
demod_output=data3;
descrambled_bits=zeros(1,32400);
for i=1:length(A_4)
    if  A_4(1,i)==B_4(1,i)%input of scrambler bits and output of scrambler bits are equal then
        descrambled_bits(1,i)=demod_output(1,i);%using same llr values
    else%input of scrambler bits and output of scrambler bits are  not equal then
        descrambled_bits(1,i)=-1* demod_output(1,i);%performing reverse llr i.e.,multiplying the bits with -1
    end
end
out=descrambled_bits;
end