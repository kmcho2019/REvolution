`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk,         // Generated clock output
    input wire enable,      // Clock enable signal (active high)
    input wire reset_n      // Active-low reset
);

    // Initialize clock and start generation
    initial begin
        clk = 0;
    end

    // Clock generation process
    always begin
        if (!reset_n) begin
            clk = 0;
            #(PERIOD);  // Wait full period after reset
        end
        else if (enable) begin
            #(PERIOD/2) clk = ~clk;  // Toggle every half period
        end
        else begin
            clk = 0;
            #(PERIOD);  // Wait when disabled
        end
    end

endmodule