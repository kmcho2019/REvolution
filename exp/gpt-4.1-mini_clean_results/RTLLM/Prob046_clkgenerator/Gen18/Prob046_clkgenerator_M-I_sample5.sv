`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period as a real number to allow odd PERIOD values
    real half_period = PERIOD / 2.0;

`ifndef SYNTHESIS
    initial begin
        clk = 0;
        forever #(half_period) clk = ~clk;
    end
`else
    // For synthesis: clk cannot be generated internally without a clock input
    // Assign initial 0 to clk, but no toggling
    initial clk = 0;
`endif

endmodule