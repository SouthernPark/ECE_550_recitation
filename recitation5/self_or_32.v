module self_or_32(data, res);
	input [31:0] data;
	output	res;
	
	wire temp[31:0];
	assign temp[31] = data[31];
	
	genvar i;
	generate	
		for(i=30;i>=0;i=i-1) begin: self_or
				or self(temp[i], temp[i+1], data[i]);
		end
	endgenerate
	
	assign res = temp[0];
	
endmodule