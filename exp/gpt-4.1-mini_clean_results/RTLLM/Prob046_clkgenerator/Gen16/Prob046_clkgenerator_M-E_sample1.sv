`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period delay
    localparam integer HALF_PERIOD = PERIOD / 2;

    // Initialize clk to 0
    initial clk = 1'b0;

    // Self-driving clock toggling triggered by clk edges
    always @(clk) begin
        // Wait half period then toggle clock
        #(HALF_PERIOD);
        clk = ~clk;
    end

endmodule