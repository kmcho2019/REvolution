`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD_NS = 10,    // Clock period in nanoseconds
    parameter ENABLE = 1         // Enable clock generation by default
) (
    output reg clk,              // Generated clock output
    input wire rst_n,           // Active-low asynchronous reset
    input wire enable           // Clock enable signal
);

// Internal enable signal combining parameter and input
wire int_enable = ENABLE && enable;

// Initialize and control the clock
always @(negedge rst_n or posedge int_enable) begin
    if (!rst_n) begin
        clk <= 1'b0;            // Reset clock to 0
    end
    else if (int_enable) begin  // Only generate clock when enabled
        clk <= 1'b0;
        forever begin
            #(PERIOD_NS/2) clk = ~clk;
        end
    end
    else begin
        clk <= 1'b0;           // Hold clock low when disabled
    end
end

endmodule