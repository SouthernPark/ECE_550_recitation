module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	/* add and subtract */
	wire [31:0] not_B;
	genvar i;
	generate	
		for(i=0;i<32;i=i+1) begin: negation
				not neg(not_B[i], data_operandB[i]);
		end
	endgenerate
	//using mux to decide whether B or not B should goes into csa
	wire [31:0] which_B;
	assign which_B = ctrl_ALUopcode[0] ? not_B : data_operandB;
	
	wire [31:0] sum_or_sub;
	csa_32 sum_sub(data_operandA, which_B, ctrl_ALUopcode[0], sum_or_sub, overflow);
	
	//TODO: check the result of sum or subtract is equal or not
	//A and B and not equal when doing subtraction if and only if the result is not zero
	self_or_32 not_equal(sum_or_sub, isNotEqual);
	
	//TODO: check whether A is less than B
	//if there is an overflow:
	//overflow can only happen is positive - negative or negative - positive
	//therefore when overflow is 1, we will set isLessthan as operandA[31]
	
	//if there is no overflow, then the subtraction res is correct,
	//therefore we just beed to check whether the res is negative which is sum_or_sub[31]
	
	//we can use a mux to do this thing
	assign isLessThan = overflow ? data_operandA[31]:sum_or_sub[31];
	
	/*and operation*/
	wire [31:0] and_res;
	and_32 and_cal(data_operandA, data_operandB, and_res);
	
	/* or operation*/
	wire [31:0] or_res;
	or_32 or_cal(data_operandA, data_operandB, or_res);
	
	/*SLL left shift*/
	wire [31:0] sll_res;
	sll sll_cal(data_operandA, ctrl_shiftamt, sll_res);
	
	/*SRA right shift*/
	wire [31:0] sra_res;
	sra sra_cal(data_operandA, ctrl_shiftamt, sra_res);
	
	//then we will select
	/* first level selection*/
	wire [31:0] option1_lev1 [3:0];
	assign option1_lev1[0] = sum_or_sub;
	assign option1_lev1[1] = sum_or_sub;
	assign option1_lev1[2] = and_res;
	assign option1_lev1[3] = or_res;
	
	wire [31:0] option2_lev1 [3:0];
	assign option2_lev1[0] = sll_res;
	assign option2_lev1[1] = sra_res;
	assign option2_lev1[2] = 32'h00000000;
	assign option2_lev1[3] = 32'h00000000;

	//ctrl_ALUopcode[2] will select between option1 and option2
	wire [31:0] level1 [3:0];
	generate	
		for(i=0;i<4;i=i+1) begin: lev1_selction
				assign level1[i] = ctrl_ALUopcode[2] ? option2_lev1[i]:option1_lev1[i];
		end
	endgenerate
	
	
	/*second level selection*/
	wire [31:0] option1_lev2 [1:0];
	assign option1_lev2[0] = level1[0];
	assign option1_lev2[1] = level1[1];
	
	wire [31:0] option2_lev2 [1:0];
	assign option2_lev2[0] = level1[2];
	assign option2_lev2[1] = level1[3];
	
	//ctrl_ALUopcode[1] will select between option1 and option2
	wire [31:0] level2 [1:0];
	assign level2[0] = ctrl_ALUopcode[1] ? option2_lev2[0]:option1_lev2[0];
	assign level2[1] = ctrl_ALUopcode[1] ? option2_lev2[1]:option1_lev2[1];
	
	/*third level*/
	assign data_result = ctrl_ALUopcode[0] ? level2[1]:level2[0];
	
endmodule
