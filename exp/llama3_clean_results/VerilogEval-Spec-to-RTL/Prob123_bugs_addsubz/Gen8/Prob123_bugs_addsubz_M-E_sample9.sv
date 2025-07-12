module adder_subtractor #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output result_is_zero
);

    // Conditionally invert b based on do_sub for subtraction
    wire [WIDTH-1:0] b_inv;
    assign b_inv = do_sub ? (~b + 1) : b;

    // Perform addition using a carry-lookahead adder (CLA) for better timing
    wire [WIDTH-1:0] sum;
    assign sum = a + b_inv;

    // Assign the result to out
    assign out = sum;

    // Tree-like OR structure for zero detection to improve timing
    wire [3:0] or_tree [2:0];
    assign or_tree[0][0] = out[0] | out[1];
    assign or_tree[0][1] = out[2] | out[3];
    assign or_tree[0][2] = out[4] | out[5];
    assign or_tree[0][3] = out[6] | out[7];

    assign or_tree[1][0] = or_tree[0][0] | or_tree[0][1];
    assign or_tree[1][1] = or_tree[0][2] | or_tree[0][3];

    assign or_tree[2][0] = or_tree[1][0] | or_tree[1][1];

    assign result_is_zero = ~or_tree[2][0];

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    adder_subtractor #(.WIDTH(8)) u_adder_subtractor (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule