`timescale 1 ns / 100 ps
module and_tb();

	// inputs to the ALU are reg type
	
   reg clock;
   reg [31:0] a, b, expected;
	
	wire [31:0] data_result;
	
	
	
	integer errors;
	
	and_32 and_test(a, b, data_result);
	
	initial
	
	begin
	
		$display($time, " << Starting the Simulation >>");
      clock = 1'b0;    // at time 0
      errors = 0;
		
		checkAnd();
		
		
		if(errors == 0) begin
			
			$display("The simulation completed without errors");
			
			end
			
			else begin
            $display("The simulation failed with %d errors", errors);
			end

        $stop;
		
	end
	
	// Clock generator
    always
         #10     clock = ~clock;
	
	task checkAnd;
        begin
            @(negedge clock);

            assign a = 32'h00000000;
            assign b = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in OR (test 1); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end
				
				
				@(negedge clock);
            assign a = 32'h0000FF00;
            assign b = 32'h0000FF00;

            @(negedge clock);
            if(data_result !== 32'h0000FF00) begin
                $display("**Error in OR (test 1); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end
				
				@(negedge clock);
            assign a = 32'h11111111;
            assign b = 32'h11111111;

            @(negedge clock);
            if(data_result !== 32'h11111111) begin
                $display("**Error in OR (test 1); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end
            
        end
    endtask
	


endmodule