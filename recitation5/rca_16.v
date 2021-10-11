module rca_16(a, b, in, sum, out, overflow);
	//this module will help me create a 16 bits RCA
	
	input [15:0]	a, b;
	input	in;
	output [15:0]	sum;
	output out, overflow;
	
	
	//this register will store the carry out in the previous full adder
	//at the beginning it is set as 0
	
	//we need 17 wires for the cary in and car out
	wire [16:0] carry;
	//carry[0] is the initial carry which depends on the input carry in
	assign carry[0]=in;
	
	//use for loop to connect the full adders
	//we need 16 full adders
	wire[16:0] res;
	genvar i;
	generate	
		for(i=0;i<16;i=i+1) begin: rca
				fa full_adder(a[i], b[i], carry[i], res[i], carry[i+1]);
		end
	endgenerate
	//the last carry is the output carry
	assign out = carry[16];
	assign sum[15:0] = res[15:0];
	//wire[16] is the CO of the last digit
	//wire[15] is the CI of the last digit
	//if CI != CO, then there is an overflow
	//we can use xor CI and CO to classify overflow
	xor over(overflow, carry[15], carry[16]);
	
endmodule