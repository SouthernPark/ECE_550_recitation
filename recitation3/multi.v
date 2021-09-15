module multi(a, b, res);
	input [4:0] a, b;
	output [9:0]	res;
	
	wire [4:0]	multiply [4:0];
	//generate the 16 mulltiply result
	genvar i, j;
	
	generate
		for(i=0;i<5; i=i+1) begin: digit_multiply_out
			for(j=0; j<5; j=j+1) begin: digit_multiply_end
				//compute a[i] * b[j]
				and digit_multi(multiply[i][j], a[i], b[j]);
			end
		end
	endgenerate
	
	assign res[0] = multiply[0][0];
	
	//first layer
	wire cout[26:1];
	wire sum[20:1];
	ha ha_0(multiply[1][0], multiply[0][1], sum[1], cout[1]);
	
	fa fa_0(multiply[2][0], multiply[1][1], multiply[0][2], sum[2], cout[2]);
	fa fa_1(multiply[2][1], multiply[1][2], multiply[0][3], sum[3], cout[3]);
	fa fa_2(multiply[2][2], multiply[1][3], multiply[0][4], sum[4], cout[4]);
	fa fa_3(multiply[3][2], multiply[2][3], multiply[1][4], sum[5], cout[5]);
	fa fa_4(multiply[4][2], multiply[3][3], multiply[2][4], sum[6], cout[6]);
	
	ha ha_1(multiply[4][3], multiply[3][4], sum[7], cout[7]);
	
	//second layer
	assign res[1] = sum[1];
	ha ha_2(sum[2], cout[1], sum[8], cout[8]);
	fa fa_5(sum[3], cout[2], multiply[3][0], sum[9], cout[9]);
	fa fa_6(cout[3], multiply[4][0], multiply[3][1], sum[10], cout[10]);
	fa fa_7(sum[5], cout[4], multiply[4][1], sum[11], cout[11]);
	
	ha ha_3(sum[6], cout[5], sum[12], cout[12]);
	ha ha_4(sum[7], cout[6], sum[13], cout[13]);
	ha ha_5(multiply[4][4], cout[7], sum[14], cout[14]);
	
	//third layer
	
	assign res[2] = sum[8];
	ha ha_6(sum[9], cout[8], sum[15], cout[15]);
	
	fa fa_8(sum[10], sum[4], cout[9], sum[16], cout[16]);
	
	ha ha_7(sum[11], cout[10], sum[17], cout[17]);
	ha ha_8(sum[12], cout[11], sum[18], cout[18]);
	ha ha_9(sum[13], cout[12], sum[19], cout[19]);
	ha ha_10(sum[14], cout[13], sum[20], cout[20]);
	
	//forth layer
	assign res[3] = sum[15];
	ha ha_11(sum[16], cout[15], res[4], cout[21]);
	
	fa fa_9(sum[17], cout[16], cout[21], res[5], cout[22]);
	fa fa_10(sum[18], cout[17], cout[22], res[6], cout[23]);
	fa fa_11(sum[19], cout[18], cout[23], res[7], cout[24]);
	fa fa_12(sum[20], cout[19], cout[24], res[8], cout[25]);
	fa fa_13(cout[14], cout[20], cout[25], res[9], cout[26]);
	
	//this is a module for Wallace Tree Multiplier
endmodule