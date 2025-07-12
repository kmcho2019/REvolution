`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0
);

    // Parameter validation
    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
        if (PERIOD % 2 != 0) $warning("PERIOD should be even for 50% duty cycle");
    end

    // Clock generation with precise timing
    always begin
        #(PERIOD/2) clk <= ~clk;
    end

    // Initial clock state (already set in port declaration)
    initial clk <= 0;

endmodule