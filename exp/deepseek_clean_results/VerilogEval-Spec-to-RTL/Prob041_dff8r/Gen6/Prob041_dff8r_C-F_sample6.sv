// Parameterized D flip-flop module with synchronous reset
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

// Option 1: Single instance for optimal PPA
DFF #(.WIDTH(WIDTH)) dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

/* Option 2: Individual instances (uncomment if needed)
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
        DFF #(.WIDTH(1)) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate
*/

endmodule