`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output wire clk,        // Generated clock output
    input wire enable,     // Clock enable signal (active high)
    input wire reset_n      // Active-low reset
);

    reg clk_reg;
    assign clk = clk_reg;

    // Clock generation process
    always begin
        if (!reset_n) begin
            clk_reg = 0;
            wait(reset_n);  // Wait for reset to deassert
        end
        else if (enable) begin
            #(PERIOD/2) clk_reg = ~clk_reg;  // Toggle every half period
        end
        else begin
            clk_reg = 0;
            wait(enable);   // Wait until enabled
        end
    end

endmodule