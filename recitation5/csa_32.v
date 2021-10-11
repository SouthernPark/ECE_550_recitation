module csa_32(a, b, in, sum, overflow);
	//this module will help us to build a 32 bits csa adder
	input [31:0] a, b;
	input in;
	
	output [31:0]	sum;
	output overflow;
	
	
	
	//firstly: calculate the lower 16 bits using RCA
	wire low_16_carry_out;
	//wire low_16_overflow;
	rca_16 low_16(a[15:0], b[15:0], in, sum[15:0], low_16_carry_out, low_16_overflow);
	
	//secondly: calculate the high 16 bits with carry_in = 0
	wire [31:16] high_16_sum_0_carry;
	wire high_16_carry_out_0;
	wire high_16_overflow_0;
	rca_16 high_16_0(a[31:16], b[31:16], 0, high_16_sum_0_carry[31:16], high_16_carry_out_0, high_16_overflow_0);
	
	//Thirdly, calculate teh high 16 bits with carry_in = 1
	wire high_16_overflow_1;
	wire [31:16] high_16_sum_1_carry;
	rca_16 high_16_1(a[31:16], b[31:16], 1, high_16_sum_1_carry[31:16], high_16_carry_out_1, high_16_overflow_1);
	
	//forthly: assign high 16 bit with mux
	assign sum[31:16] = low_16_carry_out ? high_16_sum_1_carry[31:16] : high_16_sum_0_carry[31:16];
	
	
	//finally: assign overflow with mux
	assign overflow = low_16_carry_out ? high_16_overflow_1 : high_16_overflow_0;
	
	
	
endmodule