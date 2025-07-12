`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period as integer; integer division truncates if PERIOD is odd
    localparam integer HALF_PERIOD = PERIOD / 2;

`ifndef SYNTHESIS
    initial begin
        clk = 0;
        forever #(HALF_PERIOD) clk = ~clk;
    end
`else
    // For synthesis: no internal clock generation
    initial clk = 0;
`endif

endmodule