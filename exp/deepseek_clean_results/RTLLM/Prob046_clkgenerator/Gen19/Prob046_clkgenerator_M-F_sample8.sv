`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock output
);

    // Validate parameters before use
    initial begin
        if (PERIOD < 2) begin
            $display("Error: Period must be >= 2ns");
            $finish;
        end
        $display("Clock generator initialized with period: %0dns", PERIOD);
    end

    // Calculate half period using integer division
    localparam HALF_PERIOD = PERIOD / 2;

    // Main clock generation with explicit delay units
    always begin
        #(HALF_PERIOD) clk <= ~clk;  // Non-blocking assignment
    end

    // Ensure first edge occurs at correct time
    initial #(HALF_PERIOD) clk <= 1'b1;

endmodule