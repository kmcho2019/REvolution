`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Use real type for half_period to avoid truncation in delay
    localparam real half_period = PERIOD / 2.0;

    initial begin
        clk = 1'b0;
    end

    always begin
        #(half_period);
        clk = ~clk;
    end

endmodule