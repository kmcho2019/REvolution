`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds (simulation only)
) (
    output reg clk         // Generated clock output
);

    // Calculate half period (integer division)
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial begin
        clk = 0;
    end

    // Clock generation (simulation only)
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule