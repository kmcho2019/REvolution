`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Calculate half period delay for toggling clk
    localparam integer HALF_PERIOD = PERIOD / 2;

    initial begin
        clk = 0;  // Initialize clock to zero
        forever begin
            #(HALF_PERIOD);
            clk = ~clk;
        end
    end

endmodule