// Parameterized D flip-flop module with synchronous reset
module DFF #(
    parameter WIDTH = 1,
    parameter RESET_VAL = 0
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

// Flip-flop behavior using continuous assignment
assign q = q_reg;

always @(posedge clk) begin
    q_reg <= reset ? (WIDTH'(RESET_VAL)) : d;
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

// Generate block for explicit bit-wise instantiation
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

endmodule