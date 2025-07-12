/**
 * TopModule - 8-bit Register with Synchronous Reset (Generate Implementation)
 * 
 * Features:
 * - 8 individual D flip-flops implemented via generate
 * - Positive edge-triggered
 * - Synchronous active-high reset
 * - Explicit structural implementation
 * 
 * Note: Functionally identical to array implementation but shows alternative structure
 */

module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= reset ? 1'b0 : d;
    end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Generate 8 individual DFF instances
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule