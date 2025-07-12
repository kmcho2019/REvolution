// Parameterized D flip-flop with synchronous reset
// Default width of 1 bit but can be overridden
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
    else q <= d;                    // Normal operation
end

endmodule

// Top module with configurable width (default 8 bits)
module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

// Generate block for scalable instantiation
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
        // Instantiate single-bit DFFs for better visibility
        DFF #(.WIDTH(1)) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule