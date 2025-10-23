`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period delay for toggling the clock
    localparam integer HALF_PERIOD = PERIOD / 2;

    initial begin
        // Initialize clock to 0
        clk = 1'b0;

        // Forever toggle clk every half period
        forever #(HALF_PERIOD) clk = ~clk;
    end

endmodule