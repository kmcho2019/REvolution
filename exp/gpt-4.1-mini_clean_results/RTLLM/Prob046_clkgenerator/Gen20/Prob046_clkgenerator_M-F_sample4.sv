`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Compute half period delay as integer to avoid fractional delay issues
    localparam integer HALF_PERIOD = (PERIOD > 1) ? (PERIOD / 2) : 1;

    initial begin
        clk = 0;
        forever begin
            #(HALF_PERIOD) clk = ~clk;
        end
    end

endmodule