/**
 * Optimized 8-bit Register with Clock Gating
 * @input clk     Clock signal
 * @input reset   Active-high synchronous reset
 * @input en      Enable signal (1 = normal operation, 0 = hold)
 * @input d       8-bit data input
 * @output q      8-bit data output
 * @note Features:
 * - Synchronous active-high reset
 * - Clock gating when data is stable
 * - Enable control for power savings
 */
module TopModule (
    input clk,
    input reset,
    input en,
    input [7:0] d,
    output reg [7:0] q
);

// Internal signals
wire clk_en;
reg [7:0] d_prev;

// Clock gating logic: only enable clock when data changes or reset
assign clk_en = (d != d_prev) || reset;

// Data stability tracking
always @(posedge clk) begin
    if (reset) d_prev <= 8'b0;
    else if (en) d_prev <= q;
end

// Main register with gated clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'b0;
    end
    else if (clk_en && en) begin
        q <= d;
    end
end

endmodule