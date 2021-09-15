`timescale 1 ns / 100 ps

module alu_tb();

    // inputs to the ALU are reg type
    reg            clock;
    reg [4:0] a, b, expected;


    // outputs from the ALU are wire type
    wire [4:0] res;


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
            @(negedge clock);
            assign a  = 5'b00010;
            assign b= 5'b00000;

            @(negedge clock);
            if(res !== 10'b0000000000) begin
                $display("**Error in AND (test 5); expected: %h, actual: %h", 10'b0000000000, res);
                errors = errors + 1;
            end

           
        end
    endtask

    




endmodule