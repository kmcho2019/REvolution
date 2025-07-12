`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk           // Generated clock output
);

    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end

endmodule