/**
 * TopModule - Optimized 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset
 * - Optimal PPA by default (single instance)
 * - Generate block option available
 * - Comprehensive documentation
 */

// Parameterized D Flip-Flop Module
module DFF #(
    parameter BIT_WIDTH = 1  // Configurable bit width
) (
    input clk,
    input reset,
    input [BIT_WIDTH-1:0] d,
    output reg [BIT_WIDTH-1:0] q
);

    always @(posedge clk) begin
        q <= reset ? {BIT_WIDTH{1'b0}} : d;  // Efficient synchronous reset
    end

endmodule

// Top Module Implementation
module TopModule #(
    parameter DATA_WIDTH = 8  // Default to 8-bit width
) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d,
    output [DATA_WIDTH-1:0] q
);

    // Primary Implementation: Single DFF instance (optimal PPA)
    DFF #(.BIT_WIDTH(DATA_WIDTH)) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    /* Alternative Implementation: Individual Flip-Flops (for debugging)
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : dff_gen
            DFF #(.BIT_WIDTH(1)) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
    */

endmodule