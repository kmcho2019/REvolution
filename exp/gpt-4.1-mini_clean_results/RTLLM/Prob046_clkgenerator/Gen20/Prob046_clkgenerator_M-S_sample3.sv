`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    localparam integer half_period = PERIOD / 2;

    initial begin
        clk = 0;
        forever #(half_period) clk = ~clk;
    end

endmodule