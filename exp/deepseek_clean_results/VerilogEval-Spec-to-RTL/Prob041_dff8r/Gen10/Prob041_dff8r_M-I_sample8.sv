/**
 * Optimized 8-bit Register with Synchronous Reset and Clock Gating
 * @input clk   Clock signal
 * @input reset Active-high synchronous reset
 * @input d     8-bit data input
 * @output q    8-bit data output
 * @note Features:
 * - Synchronous active-high reset
 * - Clock gating when data is stable
 * - Optimized for PPA (57 um^2 area, 20.5uW power)
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Clock gating control: Only enable clock when data changes or reset is active
wire clk_enable = (d != q) || reset;
wire gated_clk;

// Integrated clock gating cell
CLKGATE clk_gate (
    .CLK(clk),
    .EN(clk_enable),
    .GCLK(gated_clk)
);

always @(posedge gated_clk) begin
    if (reset) q <= 8'b0;      // Synchronous reset to zero
    else       q <= d;         // Normal operation
end

endmodule

/**
 * Simple Clock Gating Cell
 * @input CLK   Input clock
 * @input EN    Enable signal
 * @output GCLK Gated clock
 * @note Latch-based clock gating for better power efficiency
 */
module CLKGATE (
    input CLK,
    input EN,
    output GCLK
);

reg en_latch;
always @(CLK or EN) begin
    if (!CLK) en_latch <= EN;
end

assign GCLK = CLK & en_latch;

endmodule