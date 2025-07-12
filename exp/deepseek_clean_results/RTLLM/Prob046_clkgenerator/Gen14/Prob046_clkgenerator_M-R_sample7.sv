`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output wire clk       // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    
    // Continuous assignment compares time with half period
    assign clk = (($realtime % PERIOD) < HALF_PERIOD) ? 1'b0 : 1'b1;

endmodule