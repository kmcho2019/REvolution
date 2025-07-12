/**
 * Optimized D Flip-Flop Module with Clock Gating and Efficient Reset
 * 
 * Parameters:
 *   WIDTH - Data width (default: 8)
 * 
 * Ports:
 *   clk   - Clock input
 *   reset - Synchronous active-high reset
 *   d     - Data input
 *   q     - Data output
 */
module DFF #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Clock gating logic - only clock when data changes or reset is active
    wire gated_clk;
    reg [WIDTH-1:0] d_prev;
    wire clk_en = (d != d_prev) || reset;

    assign gated_clk = clk & clk_en;

    always @(posedge gated_clk) begin
        if (reset) begin
            q <= '0;  // SystemVerilog all-0s assignment
            d_prev <= '0;
        end else begin
            q <= d;
            d_prev <= d;
        end
    end

endmodule

/**
 * Optimized Top Module with improved PPA
 * 
 * Ports:
 *   clk   - Clock input
 *   reset - Synchronous reset
 *   d     - 8-bit data input
 *   q     - 8-bit data output
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    DFF dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule