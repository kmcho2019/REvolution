/**
 * Optimized D Flip-Flop Array with Synchronous Reset
 * 
 * Parameters:
 *   WIDTH       - Data width (default: 8)
 *   USE_CLK_GATE - Enable clock gating for power savings (default: 0)
 * 
 * Ports:
 *   clk   - Clock input (posedge triggered)
 *   reset - Synchronous active-high reset
 *   d     - Data input [WIDTH-1:0]
 *   q     - Data output [WIDTH-1:0]
 */
module TopModule #(
    parameter WIDTH = 8,
    parameter USE_CLK_GATE = 0
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Clock gating logic if enabled
    wire gated_clk;
    generate
        if (USE_CLK_GATE) begin : clk_gate
            // Simple clock gating when not in reset
            wire clk_enable = ~reset;
            latch_clock_gate u_clk_gate (
                .clk_in(clk),
                .enable(clk_enable),
                .clk_out(gated_clk)
            );
        end else begin : no_clk_gate
            assign gated_clk = clk;
        end
    endgenerate

    // Main flip-flop array
    always @(posedge gated_clk) begin
        if (reset) q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else q <= d;                    // Normal operation
    end

endmodule

// Simple clock gating cell (technology dependent)
module latch_clock_gate (
    input clk_in,
    input enable,
    output clk_out
);
    reg latch;
    always @(*) begin
        if (~clk_in) latch <= enable;
    end
    assign clk_out = clk_in & latch;
endmodule

/* Synthesis Guidelines:
1. For best PPA:
   - Use default WIDTH=8
   - Set USE_CLK_GATE=1 for power-sensitive applications
   - Ensure clock gating cell is from your technology library

2. For high-frequency designs:
   - Set USE_CLK_GATE=0 to avoid gating overhead
   - Consider adding pipeline registers if needed

3. Area vs Power tradeoff:
   - Array implementation is most area-efficient
   - Clock gating adds minimal area for significant power savings
*/