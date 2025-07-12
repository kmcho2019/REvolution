/**
 * Parameterized D Flip-Flop with Synchronous Reset
 * @param WIDTH Data width (default = 8 bits)
 * @input clk   Clock signal
 * @input reset Active-high synchronous reset
 * @input d     Data input
 * @output q    Data output
 * @note Reset clears all bits to 0 on rising clock edge
 */
module DFF #(
    parameter WIDTH = 8
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
 * @input clk   Clock signal
 * @input reset Active-high synchronous reset
 * @input d     8-bit data input
 * @output q    8-bit data output
 * @note Default implementation uses single DFF instance for optimal PPA
 * Alternative individual flip-flop implementation available via define
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Primary implementation: Single DFF instance (optimal PPA)
`ifndef USE_INDIVIDUAL_FF
DFF dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);
`else
// Alternative implementation: Individual flip-flops
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF #(.WIDTH(1)) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate
`endif

endmodule