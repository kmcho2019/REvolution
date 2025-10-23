`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk,         // Generated clock output
    input wire enable,      // Clock enable signal (active high)
    input wire reset_n      // Active-low reset
);

    // Internal half-period delay
    localparam HALF_PERIOD = PERIOD/2;

    // Clock generation process
    always begin
        // Reset handling
        if (!reset_n) begin
            clk = 0;
            wait(reset_n);  // Wait for reset deassertion
        end
        
        // Normal operation
        if (enable) begin
            #HALF_PERIOD clk = ~clk;
        end
        else begin
            // Maintain current clock state when disabled
            #HALF_PERIOD;
        end
    end

endmodule