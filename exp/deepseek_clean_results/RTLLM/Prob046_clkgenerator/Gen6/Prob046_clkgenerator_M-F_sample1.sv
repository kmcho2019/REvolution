`timescale 1ns/1ps

module clkgenerator #(parameter PERIOD = 10) (
    input reset,        // Active-high reset
    output reg clk      // Generated clock signal
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    initial begin
        clk = 0;
    end

    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule