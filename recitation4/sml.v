module sml(clk, w, out);
	
	input clk, w;
	output reg out;
	
	localparam [2:0]
		zero = 3'b000,
		one = 3'b001,
		two = 3'b010,
		three = 3'b011,
		four = 3'b100,
		five = 3'b101,
		six = 3'b110,
		seven = 3'b111;
		
	reg[2:0] stateMealy_reg, stateMealy_next;
	
	always @(posedge clk)
	begin
		stateMealy_reg <= stateMealy_next;
	end
	
	always @(stateMealy_reg, w)
	begin
		stateMealy_next = stateMealy_reg;
		out = 1'b0;
		case(stateMealy_reg)
			zero:
				if(w)
					stateMealy_next = one;
			one:
				if(w)
					stateMealy_next = two;
			two:
				if(w)
					stateMealy_next = three;
			three:
				if(w)
					stateMealy_next = four;
			four:
				if(w)
				begin
					stateMealy_next = zero;
					out = 1'b1;
				end
			five:
				if(w)
					stateMealy_next = zero;
			six:
				if(w)
					stateMealy_next = zero;
			seven:
				if(w)
					stateMealy_next = zero;
		endcase
	end
	
endmodule