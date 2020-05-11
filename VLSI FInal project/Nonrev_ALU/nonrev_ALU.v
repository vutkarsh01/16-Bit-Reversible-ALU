`timescale 1ns / 1ps

module Not(input a,output b);
assign b = !a;
endmodule

module And(input a,input b,output c);
assign c = a&b;
endmodule

module Or(input a,input b,output c);
assign c = a|b;
endmodule

module nonrev_decoder(
    input a,
    input b,
    output x0,
    output x1,
    output x2,
    output x3
    );

wire w1,w2;

Not one(a,w1);
Not two(b,w2);
And three(w1,w2,x0);
And four(w1,b,x1);
And five(a,w2,x2);
And six(a,b,x3);

endmodule

module nonrev_decoder3x8(
    input a,
    input b,
    input c,
    output x0,
    output x1,
    output x2,
    output x3,
    output x4,
    output x5,
    output x6,
    output x7
    );
	 
	 wire w1,w2,w3,w4,w5;

nonrev_decoder one(a,b,w1,w2,w3,w4);
Not two(c,w5);

And three(w1,w5,x0);
And four(w1,c,x1);

And five(w2,w5,x2);
And six(w2,c,x3);

And seven(w3,w5,x4);
And eight(w3,c,x5);

And nine(w4,w5,x6);
And ten(w4,c,x7);

endmodule

module nonrev_adder(
    input x,
    input y,
    input z,
    output S,
    output C
    );

wire w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12;

nonrev_decoder3x8 one(x,y,z,,w2,w3,w4,w5,w6,w7,w8);

Or two(w2,w3,w9);
Or three(w9,w5,w10);
Or four(w10,w8,S);

Or five(w4,w6,w11);
Or six(w7,w11,w12);
Or seven(w8,w12,C);

endmodule

module nonrev_sbit_subtractor(input [15:0] a,input [15:0] b,output [15:0] S,output cout);      /////////////calculates b-a
  wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
  wire [15:0] temp;
  assign temp[15:0] = ~a[15:0];
  
  nonrev_adder a1(temp[0],b[0],1,S[0],w1);
  nonrev_adder a2(temp[1],b[1],w1,S[1],w2);
  nonrev_adder a3(temp[2],b[2],w2,S[2],w3);
  nonrev_adder a4(temp[3],b[3],w3,S[3],w4);
  nonrev_adder a5(temp[4],b[4],w4,S[4],w5);
  nonrev_adder a6(temp[5],b[5],w5,S[5],w6);
  nonrev_adder a7(temp[6],b[6],w6,S[6],w7);
  nonrev_adder a8(temp[7],b[7],w7,S[7],w8);
  nonrev_adder a9(temp[8],b[8],w8,S[8],w9);
  nonrev_adder a10(temp[9],b[9],w9,S[9],w10);
  nonrev_adder a11(temp[10],b[10],w10,S[10],w11);
  nonrev_adder a12(temp[11],b[11],w11,S[11],w12);
  nonrev_adder a13(temp[12],b[12],w12,S[12],w13);
  nonrev_adder a14(temp[13],b[13],w13,S[13],w14);
  nonrev_adder a15(temp[14],b[14],w14,S[14],w15);
  nonrev_adder a16(temp[15],b[15],w15,S[15],cout);

endmodule

module nonrev_sbit_adder(
	 input [15:0] a,
    input [15:0] b,
    input cin,
    output [16:0] s
    );

wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;

nonrev_adder one(a[0],b[0],cin,s[0],w1);
nonrev_adder two(a[1],b[1],w1,s[1],w2);
nonrev_adder three(a[2],b[2],w2,s[2],w3);
nonrev_adder four(a[3],b[3],w3,s[3],w4);
nonrev_adder five(a[4],b[4],w4,s[4],w5);
nonrev_adder six(a[5],b[5],w5,s[5],w6);
nonrev_adder seven(a[6],b[6],w6,s[6],w7);
nonrev_adder eight(a[7],b[7],w7,s[7],w8);
nonrev_adder nine(a[8],b[8],w8,s[8],w9);
nonrev_adder ten(a[9],b[9],w9,s[9],w10);
nonrev_adder eleven(a[10],b[10],w10,s[10],w11);
nonrev_adder twelve(a[11],b[11],w11,s[11],w12);
nonrev_adder thirteen(a[12],b[12],w12,s[12],w13);
nonrev_adder fourteen(a[13],b[13],w13,s[13],w14);
nonrev_adder fifteen(a[14],b[14],w14,s[14],w15);
nonrev_adder sixteen(a[15],b[15],w15,s[15],s[16]);

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

module nonrev_ALU(input [1:0]sel,input [15:0]a,input [15:0]b,input cin,output reg [16:0]sum,input [15:0]p,input [15:0]q,output reg[15:0] diff,input[15:0] A,input [15:0] B,output reg[31:0] M,output reg[15:0] y1,output reg[15:0] y2,input [15:0]s,input [15:0]t
    );

wire [16:0]temp_sum;
wire [15:0]temp_diff;
wire [15:0]buff1;
wire [15:0]buff2;
wire [15:0]leftshift;
wire [15:0]rightshift;


nonrev_sbit_adder m1(a,b,cin,temp_sum);
nonrev_sbit_subtractor m2(p,q,temp_diff);         ///////////////////add a temporary variable
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

