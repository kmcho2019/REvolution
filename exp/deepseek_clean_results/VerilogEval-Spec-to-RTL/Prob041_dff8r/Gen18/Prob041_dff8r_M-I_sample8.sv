/**
 * TopModule - 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Fixed 8-bit width (optimized for specific requirement)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Optimized single-instance implementation
 * - Minimal area and power overhead
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else       q <= d;              // Normal operation
    end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Single instance implementation (optimized for PPA)
    DFF #(.WIDTH(8)) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule