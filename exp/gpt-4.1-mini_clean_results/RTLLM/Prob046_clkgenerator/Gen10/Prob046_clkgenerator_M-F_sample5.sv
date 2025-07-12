`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Calculate half_period as integer to avoid real delays
    localparam integer half_period = PERIOD / 2;

    initial begin
        clk = 1'b0;
        forever begin
            #(half_period);
            clk = ~clk;
        end
    end

endmodule