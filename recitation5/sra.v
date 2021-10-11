module sra(data_operandA, ctrl_shiftamt, data_result);
	
	input [31:0] data_operandA;
	//we can shift 2 to the power of 5, which is 32 bits at most
	input [4:0] ctrl_shiftamt;
	
	output [31:0] data_result;
	
	
	/*first level*/
	wire [31:0] first_level; 
	
	assign first_level[31] = data_operandA[31];
	
	genvar i;
	generate
		for(i=30; i>=0; i= i-1) begin:first
			//select between data_operandA[i] and data_operandA[i-1]
			assign first_level[i] = ctrl_shiftamt[0] ?  data_operandA[i+1] : data_operandA[i];
		end
	endgenerate
	
	/*the second level*/
	wire [31:0] second_level;
	assign second_level[31] = data_operandA[31];
	//select for the least two digit 
	assign second_level[30] = ctrl_shiftamt[1] ? data_operandA[31] : first_level[30];
	
	generate
		for(i=29; i>=0; i= i-1) begin:second
			//select between data_operandA[i] and data_operandA[i-1]
			assign second_level[i] = ctrl_shiftamt[1] ?  first_level[i+2] : first_level[i];
		end
	endgenerate
	
	/*the third level*/
	wire [31:0] third_level;
	assign third_level[31] = data_operandA[31];
	generate
		for(i=30; i>=28;i = i-1) begin:third_pre
			assign third_level[i] = ctrl_shiftamt[2] ? data_operandA[31] : second_level[i];
		end
	endgenerate

	generate
		for(i=27; i>=0; i=i-1) begin:third
			assign third_level[i] = ctrl_shiftamt[2] ? second_level[i+4] : second_level[i];
		end
	endgenerate
	
	/*forth level*/
	wire [31:0] forth_level;
	assign forth_level[31] = data_operandA[31];
	generate
		for(i=30; i>=24;i = i-1) begin:forth_pre
			assign forth_level[i] = ctrl_shiftamt[3] ? data_operandA[31] : third_level[i];
		end
	endgenerate
	
	generate
		for(i=23; i>=0; i=i-1) begin:forth
			assign forth_level[i] = ctrl_shiftamt[3] ? third_level[i+8] : third_level[i];
		end
	endgenerate
	
	//the fifth level -> move 0 or 16 bits, specified by the least significant digit ctrl_shiftamt[4]
	assign data_result[31] = data_operandA[31];
	generate
		for(i=30; i>=16;i = i-1) begin:fifth_pre
			assign data_result[i] = ctrl_shiftamt[4] ? data_operandA[31] : forth_level[i];
		end
	endgenerate
	
	generate
		for(i=15; i>=0; i=i-1) begin:fifth
			assign data_result[i] = ctrl_shiftamt[4] ? forth_level[i+16] : forth_level[i];
		end
	endgenerate
	
	
endmodule