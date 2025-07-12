`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0
);

    // Parameter validation
    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
    end

    // Clock generation (simulation only)
    always begin
        #(PERIOD/2) clk = 1;
        #(PERIOD/2) clk = 0;
    end

endmodule