`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock (initialized to 0)
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Simple clock generation using delays
    initial begin
        forever begin
            #HALF_PERIOD clk = ~clk;
        end
    end

endmodule