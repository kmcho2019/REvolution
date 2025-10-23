`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

localparam integer HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0;
    forever #(HALF_PERIOD) clk = ~clk;
end

endmodule