`timescale 1ns/1ps

// WARNING: This module is for simulation purposes only
// Not suitable for synthesis - use dedicated clock resources for hardware

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk         // Generated clock output
);

    // Initialize clock (simulation only)
    initial clk = 0;

    // Clock generation (simulation only)
    always begin
        #(PERIOD/2) clk = ~clk;
    end

endmodule