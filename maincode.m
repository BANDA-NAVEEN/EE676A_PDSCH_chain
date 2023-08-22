%EE676A SIMULATION BASED DESIGN OF 5G NEW RADIO WIRELESS STANDARDS
%MATLAB Assignment-3:Performing code block segmentatiom and ldpc coding and
%ratematching,interleaving,scrambling,QPSK modulation and demodulation,descrambling,deinterleaving,rate recovery
%decoding,vadlidating code block and transport block crc validation
%Student Name:BANDA NAVEEN (22104061)
clc;
clear all;
close all;
tbsize=20496;%transport block size length tb=20496 sended from MAC layer
G=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];%standard polynomial used to generate generator polynomial
nbg = 1;% Base graph 1
nldpcdecits = 25;% Decode with maximum no of iteration
message=randi([0 1],1,tbsize);%randomly generating the message information of 20496 bits
[trans_block,tb_crc]=gen_crc(message,G);%generating the tb block crc and appending to the transport block using the
B=length(trans_block);%length of transport block
Kcb=8448;%maximum length of LDPC encoder
L=24;%maximum appending crc parity bits
X= B/(Kcb-L);%calculating the no.of code blocks required for segmentation
C=ceil(X);%no.of code blocks
Bc=B+(C*L);%effective data payload  
Kc=Bc/C;%lenth of the message bits+code block crc
Zc=320;%lifting factor generated based on base graph(kb*zc>kc)
Kb=22;%no.of systematic columns
K=Kb*Zc;%no.of bits input to the LDPC encoder
F=K-Kc; %no of filler bits so as to statisfy the condition of parity check matrix of the LDPC encoder
N=66*Zc;%output of the ldpc encoder
G1=100*162*2;%total no of bits to be modulated-generated using no of PRBS,modulation order
E=G1/C;%no of bits ouput of each rate matched block
A_1=reshape(trans_block,C,[]);%segmenting the tb+tb-crc bits into three arrays of size 6864

%flow of PDSCCH chain 
for i= 1:C
[A_2,cb_crc]=gen_crc(A_1(i,:),G);%generating and attaching code block crc
A_2=[A_2,-1*zeros(1,F)];%appending filler bits
ldpc_coded_bits = double(LDPCEncode(A_2',nbg));%LDPC output reading the data column wise
A_3(i,:)=ldpc_coded_bits(1:E);%performing the rate matching of taking E bits of each ldpc output
I(i,:)=interleaver(A_3(i,:));%interleaving the each block
end
%concantinating the all three rate matched code blocks
B_4=reshape(I,1,[]);
%performing the scrambling
x1=[1,zeros(1,30)];%one input of gold sequence generation 
x2=[ones(1,7),zeros(1,24)];%another input of gold sequence generation based on user RNTI 255
c=goldsequence(x1,x2);%gold sequence generated bits
for i=1:length(c)
    A_4(1,i)=double(xor(B_4(1,i),c(1,i)));%performing the scrambling
end
%performing QPSK modulation and Demodulation by sending the two BPSK symbols parallel as one QPSK symbol
noise_power = (10^-5);
%% In phase modulation
bitsi=A_4(1:2:end);%taking alternative bits called as inphase bits
bitsi=2*(bitsi-0.5);%bpsk modualtion of inphase bits
noisei = sqrt(noise_power)*(randn(size(bitsi)));
Rx_i=bitsi+noisei;
llr0_i =  abs(-1 + Rx_i);   % BPSK demod using log likelihood ratio
llr1_i =  abs(1 + Rx_i);    % BPSK demod

llr_i = log(llr0_i./llr1_i);      % ldpc decoder requires log(p(r/0)/p(r/1))
demod_output_i = llr_i;%demodulating the inphase bits
%% Q_phase modulation
bitsq=A_4(2:2:end);%taking alternative bits called as quadrature bits
bitsq=2*(bitsq-0.5);%bpsk modualtion of quadrature bits
noiseq = sqrt(noise_power)*(randn(size(bitsq)));
Rx_q=bitsq+noiseq;
llr0_q =  abs(-1 + Rx_q);   % BPSK demod using log likelihood ratio
llr1_q =  abs(1 + Rx_q);    % BPSK demod

llr_q = log(llr0_q./llr1_q);      % ldpc decoder requires log(p(r/0)/p(r/1))
demod_output_q= llr_q;%demodulating the quadrature bits
%% Rx_symbols
demod_output=[demod_output_i;demod_output_q];%combing decoded inphase and quadrature bits
demod_output=demod_output(:)';
descrambledbits=zeros(1,32400);
descrambledbits=descrambler(A_4,B_4,demod_output);%performing the descrambling 
%segmenting the descrambing bits into three code blocks
A_5=reshape(descrambledbits,C,[]);
p=0.5*ones(1,10320);%neutal information bits
for i=1:C
    W(i,:)=deinterleaver(A_5(i,:));%performing the deinterleaving
    A_6=[W(i,:),p];%adding puntured bits and input to ldpc decoder
    decoded_data = double(LDPCDecode(A_6',nbg,nldpcdecits));%decoded bits of LDPC decoder 
    A_7=decoded_data(1:(length(decoded_data)-F));%removing filler bits
    A_7=A_7';
    cb_checksum=check_crc(A_7,G);%validating code block crc of each block
    if sum(cb_checksum)==0
     A_8(i,:)=A_7(1:(length(A_7)-24));%if cb-crc validation success,remving cb-crc bits 
       display ('code block crc validation is succesful');
    else
    display ('error occured in  code block crc,request for particular code block retransmission');
    end  
end
%concanting the transport block bits which was segmented @transmitter
A_9=reshape(A_8,1,[]);
tb_checksum=check_crc(A_9,G);%validating transport block crc of each block
if sum(tb_checksum)==0
   display ('transport block crc validation is succesful,data received suscessfully without any erros');
else
   display ('error in transport,request for retransmisson');
end