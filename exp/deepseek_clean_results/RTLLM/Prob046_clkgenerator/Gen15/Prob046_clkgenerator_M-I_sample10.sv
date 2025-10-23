`timescale 1ns/1ps

/*
 * Improved Clock Generator Module
 * Generates a stable clock signal with configurable period
 */
module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock (initialized to 0)
);

    // Calculate half period in time units
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation process
    always begin
        #HALF_PERIOD clk = ~clk;
    end

    // Initial block for simulation clarity (optional)
    initial begin
        $display("Clock generator started with period = %0d ns", PERIOD);
    end

endmodule