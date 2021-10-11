module and_32(data_operandA, data_operandB, data_result);
	//this module will return the and result of A and B
	input [31:0] data_operandA, data_operandB;
	
	output [31:0] data_result;
	
	//create 32 and gates
	genvar i;
	generate	
		for(i=0;i<32;i=i+1) begin: andGate
				and and_gate(data_result[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
endmodule