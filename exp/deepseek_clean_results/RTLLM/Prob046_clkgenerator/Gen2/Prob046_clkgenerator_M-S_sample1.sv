`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk
);

    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
        clk = 0;
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end

endmodule