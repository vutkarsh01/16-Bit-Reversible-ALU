`timescale 1ns / 1ps

module fredGate (a,b,c,p,q,r);
	input a,b,c;
	output p,q,r;
	assign p=a;
	assign q=((~a)&b)^(a&c);
	assign r=((~a)&c)^(a&b);
endmodule

module decoder(a,b,x0,x1,x2,x3
    );
input a,b;
output x0,x1,x2,x3;

wire w7,w4,w6;

fredGate three(b,0,1,,w6,w7);     
fredGate one(a,0,w6,w4,x3,x1);
fredGate two(w4,0,w7,,x2,x0);

endmodule

module decoder3x8(a,b,c,x0,x1,x2,x3,x4,x5,x6,x7
    );
input a,b,c;
output x0,x1,x2,x3,x4,x5,x6,x7;
wire w1,w2,w3,w4,w5,w6,w7;

decoder oone(a,b,w4,w3,w2,w1);
fredGate one(c,0,w1,w5,x7,x6);
fredGate two(w5,0,w2,w6,x5,x4);
fredGate three(w6,0,w3,w7,x3,x2);
fredGate four(w7,0,w4,,x1,x0);

endmodule

module adder(x,y,z,S,C
    );
	 input x,y,z;
	 output S,C;

wire w10,w2,w3,w4,w5,w6,w7,w8,w11,w12,w13;

decoder3x8 one(x,y,z,,w2,w3,w4,w5,w6,w7,w8);

assign S = w2|w3|w5|w8;
assign C = w4|w6|w7|w8;

endmodule

module sbit_adder(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [16:0] s
    );
wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;

adder one(a[0],b[0],cin,s[0],w1);
adder two(a[1],b[1],w1,s[1],w2);
adder three(a[2],b[2],w2,s[2],w3);
adder four(a[3],b[3],w3,s[3],w4);
adder five(a[4],b[4],w4,s[4],w5);
adder six(a[5],b[5],w5,s[5],w6);
adder seven(a[6],b[6],w6,s[6],w7);
adder eight(a[7],b[7],w7,s[7],w8);
adder nine(a[8],b[8],w8,s[8],w9);
adder ten(a[9],b[9],w9,s[9],w10);
adder eleven(a[10],b[10],w10,s[10],w11);
adder twelve(a[11],b[11],w11,s[11],w12);
adder thirteen(a[12],b[12],w12,s[12],w13);
adder fourteen(a[13],b[13],w13,s[13],w14);
adder fifteen(a[14],b[14],w14,s[14],w15);
adder sixteen(a[15],b[15],w15,s[15],s[16]);

endmodule

module sbit_subtractor(input [15:0] a,input [15:0] b,output [15:0] S,output cout);      /////////////calculates b-a
  wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
  wire [15:0] temp;
  assign temp[15:0] = ~a[15:0];
  
  adder a1(temp[0],b[0],1,S[0],w1);
  adder a2(temp[1],b[1],w1,S[1],w2);
  adder a3(temp[2],b[2],w2,S[2],w3);
  adder a4(temp[3],b[3],w3,S[3],w4);
  adder a5(temp[4],b[4],w4,S[4],w5);
  adder a6(temp[5],b[5],w5,S[5],w6);
  adder a7(temp[6],b[6],w6,S[6],w7);
  adder a8(temp[7],b[7],w7,S[7],w8);
  adder a9(temp[8],b[8],w8,S[8],w9);
  adder a10(temp[9],b[9],w9,S[9],w10);
  adder a11(temp[10],b[10],w10,S[10],w11);
  adder a12(temp[11],b[11],w11,S[11],w12);
  adder a13(temp[12],b[12],w12,S[12],w13);
  adder a14(temp[13],b[13],w13,S[13],w14);
  adder a15(temp[14],b[14],w14,S[14],w15);
  adder a16(temp[15],b[15],w15,S[15],cout);

endmodule

module multiplier(output reg [15:0] buff1,output reg [15:0] buff2, input [15:0]A,input [15:0]B);

reg B0;
reg [15:0]C;

integer i;

always@*
begin
buff1 = 0;
C[15:0] = B[15:0];
    for(i=0;i<16;i=i+1)
    begin
        B0 = C[0];
        if(B0==1)
            begin
            buff1[15:0] = buff1 [15:0]+ A[15:0];
            C = C >> 1;
            C[15] = buff1[0];
            buff1 = buff1 >> 1;
            end
        else if(B0==0)
            begin
            C = C >> 1;
            C[15] = buff1[0];
            buff1 = buff1 >> 1;
            end
        buff2 = C[15:0];    
    end       
end
endmodule

module shifter(
    output reg [15:0] leftshift,
    output reg [15:0] rightshift,
    input [15:0] j,
    input [15:0] k);
always@(k)
begin
leftshift <= j<<k;
rightshift <= j>>k;
end

endmodule

module ALU(input [1:0]sel,input [15:0]a,input [15:0]b,input cin,output reg [16:0]sum,input [15:0]p,input [15:0]q,output reg[15:0] diff,input[15:0] A,input [15:0] B,output reg[31:0] M,output reg[15:0] y1,output reg[15:0] y2,input [15:0]s,input [15:0]t
    );

wire [16:0]temp_sum;
wire [15:0]temp_diff;
wire [15:0]buff1;
wire [15:0]buff2;
wire [15:0]leftshift;
wire [15:0]rightshift;

sbit_adder m1(a,b,cin,temp_sum);
sbit_subtractor m2(p,q,temp_diff);
multiplier m3(buff1,buff2,A,B);
shifter m4(leftshift,rightshift,s,t);	 
	 
always@*

	begin
		if(sel==2'b00)
		 begin
		    y1[15:0]<= 16'bz;
			 y2[15:0]<= 16'bz;
			 sum[16:0] <= temp_sum[16:0];
          diff[15:0] <= 16'bz;
          M[31:0] <=	32'bz;		 
		 end
		else if(sel==2'b01)
		 begin
		    y1[15:0]<= 16'bz;
			 y2[15:0]<= 16'bz;
			 sum[16:0] <= 17'bz;
          diff[15:0] <= temp_diff;        				
			 M[31:0] <=	32'bz;
		 end
		else if(sel==2'b10)
		 begin
		    y1[15:0]<= 16'bz;
			 y2[15:0]<= 16'bz;
		    sum[16:0] <= 17'bz;
			 diff[15:0] <= 16'bz;
			 M[31:0] <= {buff1[15:0],buff2[15:0]};
		 end
		else if(sel==2'b11)
		begin
		    y1[15:0] <= leftshift[15:0];
			 y2[15:0] <= rightshift[15:0];
		    sum[16:0] <= 17'bz;
			 diff[15:0] <= 16'bz;
			 M[31:0] <= 32'bz;
		end
	end
	
endmodule

