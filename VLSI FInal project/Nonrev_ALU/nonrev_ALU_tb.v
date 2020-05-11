`timescale 1ns / 1ps

module nonrev_ALU_tb;

	reg [1:0] sel;
	reg [15:0] a;
	reg [15:0] b;
	reg cin;
	reg [15:0] p;
	reg [15:0] q;
	reg [15:0] A;
	reg [15:0] B;
	reg [15:0] s;
	reg [15:0] t;

	wire [16:0] sum;
	wire [15:0] diff;
	wire [31:0] M;
	wire [15:0] y1;
	wire [15:0] y2;

	nonrev_ALU uut (
		.sel(sel), 
		.a(a), 
		.b(b), 
		.cin(cin), 
		.sum(sum), 
		.p(p), 
		.q(q), 
		.diff(diff), 
		.A(A), 
		.B(B), 
		.M(M), 
		.y1(y1), 
		.y2(y2), 
		.s(s), 
		.t(t)
	);

	initial begin
		sel = 0;
		a = 340;
		b = 45;
		cin = 1;
		p = 0;
		q = 0;
		A = 0;
		B = 0;
		s = 0;
		t = 0;

		#100;
        
		sel = 0;
		a = 678;
		b = 32;
		cin = 1;
		p = 0;
		q = 0;
		A = 0;
		B = 0;
		s = 0;
		t = 0;

		#100;

		sel = 1;
		a = 0;
		b = 0;
		cin = 0;
		p = 30;
		q = 450;
		A = 0;
		B = 0;
		s = 0;
		t = 0;

		#100;

		sel = 1;
		a = 0;
		b = 0;
		cin = 0;
		p = 123;
		q = 456;
		A = 0;
		B = 0;
		s = 0;
		t = 0;

		#100;

		sel = 2;
		a = 0;
		b = 0;
		cin = 0;
		p = 0;
		q = 0;
		A = 342;
		B = 56;
		s = 0;
		t = 0;

		#100;

		sel = 2;
		a = 0;
		b = 0;
		cin = 0;
		p = 0;
		q = 0;
		A = 234;
		B = 123;
		s = 0;
		t = 0;

		#100;

		sel = 3;
		a = 0;
		b = 0;
		cin = 0;
		p = 0;
		q = 0;
		A = 0;
		B = 0;
		s = 234;
		t = 3;

		#100;

		sel = 3;
		a = 0;
		b = 0;
		cin = 0;
		p = 0;
		q = 0;
		A = 0;
		B = 0;
		s = 1;
		t = 5;

		#100;

	end
      
endmodule


