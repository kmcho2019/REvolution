`timescale 1ns/1ps

/*
 * Clock Generator Module (Simulation Only)
 * 
 * Parameters:
 *   PERIOD - Clock period in ns (must be even and >= 2)
 *   ENABLE - Enable continuous clock generation (1) or single pulse (0)
 * 
 * Outputs:
 *   clk - Generated clock signal
 */
module clkgenerator #(
    parameter PERIOD = 10,    // Clock period in ns
    parameter ENABLE = 1      // Continuous clock enable
) (
    output reg clk = 0        // Generated clock (initialized to 0)
);

    // Parameter validation
    initial begin
        if (PERIOD < 2) begin
            $error("PERIOD must be >= 2 ns");
            $finish;
        end
        if (PERIOD % 2 != 0) begin
            $warning("PERIOD should be even for 50% duty cycle");
        end
    end

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation process
    initial begin
        if (ENABLE) begin
            forever #HALF_PERIOD clk = ~clk;
        end else begin
            #HALF_PERIOD clk = 1;
            #HALF_PERIOD clk = 0;
        end
    end

endmodule