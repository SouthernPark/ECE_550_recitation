`timescale 1 ns / 100 ps

module multi_tb();

    // inputs to the ALU are reg type
    reg            clock;
    reg [4:0] a, b, expected;


    // outputs from the ALU are wire type
    wire [9:0] res;


    // Tracking the number of errors
    integer errors;

    // Instantiate ALU
    multi test(a, b, res);

    initial

    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
        errors = 0;

        checkMulti();

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



    task checkMulti;
        begin
				//1
            @(negedge clock);
            assign a  = 5'd20;
            assign b= 5'd20;

            @(negedge clock);
            if(res !== 10'd400) begin
                $display("**Error in AND (test 0); expected: %h, actual: %h", 10'd400, res);
                errors = errors + 1;
            end
				
				//2
				@(negedge clock);
            assign a  = 5'd31;
            assign b= 5'd31;

            @(negedge clock);
            if(res !== 10'd961) begin
                $display("**Error in AND (test 1); expected: %h, actual: %h", 10'd961, res);
                errors = errors + 1;
            end
				
				@(negedge clock);
            assign a  = 5'd1;
            assign b= 5'd0;

            @(negedge clock);
            if(res !== 10'd0) begin
                $display("**Error in AND (test 2); expected: %h, actual: %h", 10'd0, res);
                errors = errors + 1;
            end
				
				@(negedge clock);
            assign a  = 5'd0;
            assign b= 5'd0;

            @(negedge clock);
            if(res !== 10'd0) begin
                $display("**Error in AND (test 3); expected: %h, actual: %h", 10'd0, res);
                errors = errors + 1;
            end
				
				@(negedge clock);
            assign a  = 5'd0;
            assign b= 5'd1;

            @(negedge clock);
            if(res !== 10'd0) begin
                $display("**Error in AND (test 4); expected: %h, actual: %h", 10'd0, res);
                errors = errors + 1;
            end
				
           
        end
    endtask

    




endmodule