`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

real half_period;

initial begin
    half_period = PERIOD / 2.0;  // real division to handle odd PERIODs correctly
    clk = 0;
    forever #(half_period) clk = ~clk;
end

endmodule