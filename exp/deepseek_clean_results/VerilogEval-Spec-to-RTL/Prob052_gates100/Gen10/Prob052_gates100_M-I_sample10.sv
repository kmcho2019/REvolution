module TopModule #(
    parameter WIDTH = 100
) (
    input [WIDTH-1:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Binary tree reduction for AND
    wire [6:0] and_tree;  // 7 levels for 100 inputs (2^7=128)
    assign and_tree[0] = &in[15:0];
    assign and_tree[1] = &in[31:16];
    assign and_tree[2] = &in[47:32];
    assign and_tree[3] = &in[63:48];
    assign and_tree[4] = &in[79:64];
    assign and_tree[5] = &in[95:80];
    assign and_tree[6] = &in[99:96];
    assign out_and = &and_tree;

    // Binary tree reduction for OR
    wire [6:0] or_tree;
    assign or_tree[0] = |in[15:0];
    assign or_tree[1] = |in[31:16];
    assign or_tree[2] = |in[47:32];
    assign or_tree[3] = |in[63:48];
    assign or_tree[4] = |in[79:64];
    assign or_tree[5] = |in[95:80];
    assign or_tree[6] = |in[99:96];
    assign out_or = |or_tree;

    // Optimal XOR implementation
    assign out_xor = ^in;

endmodule