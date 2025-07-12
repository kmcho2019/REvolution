`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk = 0
);

initial
    forever #(PERIOD/2) clk = ~clk;

endmodule