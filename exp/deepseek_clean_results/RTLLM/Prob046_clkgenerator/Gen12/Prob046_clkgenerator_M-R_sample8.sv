`timescale 1ns/1ps

/*
 * Simple Clock Generator Module
 * Generates a periodic clock signal with specified PERIOD
 * Toggles every PERIOD/2 time units for 50% duty cycle
 */
module clkgenerator #(
    parameter PERIOD = 10    // Clock period in ns
) (
    output reg clk = 0       // Generated clock (initialized to 0)
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation process
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule