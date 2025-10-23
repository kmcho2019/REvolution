`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Calculate half period delay with rounding for odd values
    localparam integer HALF_PERIOD = (PERIOD + 1) / 2;

    // Initialize clk to 0 at simulation start
    initial begin
        clk = 0;
    end

    // Toggle clk every half period forever
    initial begin
        forever begin
            #(HALF_PERIOD) clk = ~clk;
        end
    end

endmodule