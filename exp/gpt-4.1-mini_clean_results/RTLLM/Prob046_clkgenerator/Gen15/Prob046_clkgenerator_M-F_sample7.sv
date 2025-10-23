`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period duration (integer division)
    localparam integer HALF_PERIOD = PERIOD / 2;

    initial begin
        clk = 1'b0;           // Initialize clock to 0
        forever begin
            #(HALF_PERIOD);
            clk = ~clk;       // Toggle clock every half period
        end
    end

endmodule