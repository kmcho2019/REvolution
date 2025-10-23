/**
 * Parameterized D Flip-Flop with Synchronous Reset
 * Default width of 1 bit, can be overridden
 * Reset sets all bits to 0 synchronously
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

/**
 * Top Module with 8-bit Register
 * Uses parameterized DFF module
 * Default implementation uses single DFF instance for optimal PPA
 * Alternative individual flip-flop implementation is commented
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Primary implementation: Single DFF instance (optimal for PPA)
DFF #(.WIDTH(8)) dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

/* Alternative implementation: Individual flip-flops (uncomment if needed)
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
*/

endmodule