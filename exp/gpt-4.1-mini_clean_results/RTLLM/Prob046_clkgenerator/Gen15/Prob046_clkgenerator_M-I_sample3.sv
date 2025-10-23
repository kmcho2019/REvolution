`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period calculated once
    localparam integer HALF_PERIOD = PERIOD / 2;

    // Initialize clock to 0 at simulation start
    initial begin
        clk = 1'b0;
    end

    // Toggle clock every half period forever
    always begin
        #(HALF_PERIOD);
        clk = ~clk;
    end

endmodule