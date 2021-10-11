module sll(data_operandA, ctrl_shiftamt, data_result);
	//this module will left shift operand A left in certain amount
	input [31:0] data_operandA;
	//we can shift 2 to the power of 5, which is 32 bits at most
	input [4:0] ctrl_shiftamt;
	
	output [31:0] data_result;
	
	//there will be five level of muxs
	/*the first level -> move 0 or 1 bits, specified by the least significant digit ctrl_shiftamt[0]*/
	
	//select for the least digit
	wire [31:0] first_level; 
	assign first_level[0] = ctrl_shiftamt[0] ? 0 : data_operandA[0];
	genvar i;
	generate
		for(i=1; i<32; i= i+1) begin:first
			//select between data_operandA[i] and data_operandA[i-1]
			assign first_level[i] = ctrl_shiftamt[0] ?  data_operandA[i-1] : data_operandA[i];
		end
	endgenerate
	
	/*the second level -> move 0 or 2 bits, specified by the least significant digit ctrl_shiftamt[1]*/
	
	wire [31:0] second_level;
	//select for the least two digit 
	assign second_level[0] = ctrl_shiftamt[1] ? 0 : first_level[0];
	assign second_level[1] = ctrl_shiftamt[1] ? 0 : first_level[1];
	generate
		for(i=2; i<32; i=i+1) begin:second
			assign second_level[i] = ctrl_shiftamt[1] ? first_level[i-2] : first_level[i];
		end
	endgenerate
	
	//the third level -> move 0 or 4 bits, specified by the least significant digit ctrl_shiftamt[2]
	wire [31:0] third_level;
	generate
		for(i=0; i<4;i = i+1) begin:third_pre
			assign third_level[i] = ctrl_shiftamt[2] ? 0 : second_level[i];
		end
	endgenerate

	generate
		for(i=4; i<32; i=i+1) begin:third
			assign third_level[i] = ctrl_shiftamt[2] ? second_level[i-4] : second_level[i];
		end
	endgenerate
	
	//the forth level -> move 0 or 8 bits, specified by the least significant digit ctrl_shiftamt[3]
	wire [31:0] forth_level;
	generate
		for(i=0; i<8;i = i+1) begin:forth_pre
			assign forth_level[i] = ctrl_shiftamt[3] ? 0 : third_level[i];
		end
	endgenerate
	
	generate
		for(i=8; i<32; i=i+1) begin:forth
			assign forth_level[i] = ctrl_shiftamt[3] ? third_level[i-8] : third_level[i];
		end
	endgenerate
	
	
	//the fifth level -> move 0 or 16 bits, specified by the least significant digit ctrl_shiftamt[4]

	generate
		for(i=0; i<16;i = i+1) begin:fifth_pre
			assign data_result[i] = ctrl_shiftamt[4] ? 0 : forth_level[i];
		end
	endgenerate
	
	generate
		for(i=16; i<32; i=i+1) begin:fifth
			assign data_result[i] = ctrl_shiftamt[4] ? forth_level[i-16] : forth_level[i];
		end
	endgenerate
	
endmodule