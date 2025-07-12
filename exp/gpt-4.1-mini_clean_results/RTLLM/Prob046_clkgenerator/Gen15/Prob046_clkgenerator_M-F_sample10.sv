`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk = 0
);

    // Calculate half period delay for toggling
    localparam integer HALF_PERIOD = PERIOD / 2;

    // Generate clock by toggling every half period
    always begin
        #(HALF_PERIOD) clk = ~clk;
    end

endmodule