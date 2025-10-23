`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0
);

    // Parameter validation
    initial begin
        if (PERIOD <= 0) begin
            $fatal("Error: PERIOD must be positive (given %0d)", PERIOD);
        end
    end

    // Clock generation (simulation only)
    always begin
        #(PERIOD/2) clk = ~clk;
    end

    // Initial clock state
    initial begin
        clk = 0;
    end

endmodule