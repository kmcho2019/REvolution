`timescale 1ns/1ps

module clkgenerator #(parameter real PERIOD = 10.0) (
    output reg clk
);

    initial begin
        clk = 0;
        forever #(PERIOD/2.0) clk = ~clk;
    end

endmodule