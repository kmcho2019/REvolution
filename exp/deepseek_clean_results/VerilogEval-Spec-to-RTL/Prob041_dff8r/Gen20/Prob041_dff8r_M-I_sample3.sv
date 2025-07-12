/**
 * Optimized TopModule - 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Two implementation styles:
 *   - SINGLE: Single 8-bit register (better PPA)
 *   - GENERATE: Individual flip-flops (better for debug)
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

    // Default to SINGLE implementation for best PPA
    DFF #(.WIDTH(8)) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    /* Alternative GENERATE implementation (uncomment if needed)
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF #(.WIDTH(1)) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
    */

endmodule