`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk         // Generated clock output
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial begin
        clk = 0;
    end

    // Clock generation with simple delay-based toggling
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule