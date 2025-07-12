`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10)(
    output reg clk = 0
);

localparam HALF_PERIOD = PERIOD / 2;

// Using always block with time delay sensitivity for toggling clk periodically
always #(HALF_PERIOD) clk = ~clk;

endmodule