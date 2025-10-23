`timescale 1ns / 1ps

module clkgenerator #(parameter real PERIOD = 10.0)(
    output reg clk
);

real half_period;

initial begin
    clk = 0;
    half_period = PERIOD / 2.0;
    forever #(half_period) clk = ~clk;
end

endmodule