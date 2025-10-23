/**
 * Optimized TopModule - 8-bit Register with Synchronous Reset
 * 
 * Key Improvements:
 * - Single optimal implementation (no GENERATE/SINGLE option)
 * - Clock gating for power reduction
 * - Power-aware reset strategy
 * - Simplified hierarchy
 * - Removed parameter validation (handled in pre-synthesis)
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Clock gating logic - only clock when inputs change
    reg [WIDTH-1:0] d_prev;
    wire clk_enable = (d != d_prev) || reset;
    wire gated_clk = clk & clk_enable;

    // Reset synchronizer for clean reset timing
    reg sync_reset;
    always @(posedge clk) begin
        sync_reset <= reset;
        d_prev <= d;
    end

    // Optimized DFF array
    reg [WIDTH-1:0] q_reg;
    always @(posedge gated_clk) begin
        if (sync_reset) q_reg <= {WIDTH{1'b0}};
        else            q_reg <= d;
    end

    assign q = q_reg;

endmodule