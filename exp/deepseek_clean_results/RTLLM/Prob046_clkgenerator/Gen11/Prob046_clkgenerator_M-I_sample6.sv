`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds (must be positive and even)
) (
    output reg clk,        // Generated clock output
    input wire enable = 1  // Optional clock enable (defaults to on)
);

    // Validate parameters
    initial begin
        if (PERIOD <= 0) begin
            $error("PERIOD must be positive (given: %0d)", PERIOD);
            $finish;
        end
        if (PERIOD % 2 != 0) begin
            $warning("PERIOD should be even for 50% duty cycle (given: %0d)", PERIOD);
        end
    end

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial begin
        clk = 0;
        if (enable) begin
            forever begin
                #HALF_PERIOD clk = ~clk;
            end
        end
    end

    // Optional: Monitor clock changes for debugging
    always @(clk) begin
        if (enable) begin
            $display("[%0t] Clock %0s", $time, clk ? "HIGH" : "LOW");
        end
    end

endmodule