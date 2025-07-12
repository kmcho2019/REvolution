`timescale 1ns/1ps

/*
 * Robust Clock Generator Module
 * Generates periodic clock with specified PERIOD
 * Proper initialization and reliable timing control
 */
module clkgenerator #(
    parameter PERIOD = 10    // Clock period in ns
) (
    output reg clk           // Generated clock
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Initial block for proper initialization
    initial begin
        clk = 0;
    end

    // Clock generation process
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule