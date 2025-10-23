`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    // Compute half period in integer units
    localparam integer half_period = PERIOD / 2;

    // Counter to track elapsed time units
    integer count;

    initial begin
        clk = 1'b0;
        count = 0;
    end

    // Use an always block with a 1-time-unit delay to emulate a time base
    always begin
        #1; // wait 1 time unit
        count = count + 1;
        if (count >= half_period) begin
            clk = ~clk;
            count = 0;
        end
    end

endmodule