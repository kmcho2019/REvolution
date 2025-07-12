`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    localparam integer HALF_PERIOD = (PERIOD + 1) / 2;  // rounds up for odd PERIODs

    initial clk = 0;

    always begin
        #(HALF_PERIOD) clk = ~clk;
    end

endmodule