module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [3:0] and_tree_out;
    wire [3:0] or_tree_out;
    wire [3:0] xor_tree_out;

    // Divide the 100 inputs into 4 groups of 25 inputs each
    GroupModule group0(.in(in[24:0]), .and_out(and_tree_out[0]), .or_out(or_tree_out[0]), .xor_out(xor_tree_out[0]));
    GroupModule group1(.in(in[49:25]), .and_out(and_tree_out[1]), .or_out(or_tree_out[1]), .xor_out(xor_tree_out[1]));
    GroupModule group2(.in(in[74:50]), .and_out(and_tree_out[2]), .or_out(or_tree_out[2]), .xor_out(xor_tree_out[2]));
    GroupModule group3(.in(in[99:75]), .and_out(and_tree_out[3]), .or_out(or_tree_out[3]), .xor_out(xor_tree_out[3]));

    // Combine the outputs of each group using a final level of logic
    assign out_and = and_tree_out[0] & and_tree_out[1] & and_tree_out[2] & and_tree_out[3];
    assign out_or = or_tree_out[0] | or_tree_out[1] | or_tree_out[2] | or_tree_out[3];
    assign out_xor = xor_tree_out[0] ^ xor_tree_out[1] ^ xor_tree_out[2] ^ xor_tree_out[3];

endmodule

module GroupModule(
    input  [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    wire [4:0] and_tree;
    wire [4:0] or_tree;
    wire [4:0] xor_tree;

    // 5-level tree structure for AND, OR, and XOR
    assign and_tree[0] = in[0] & in[1];
    assign and_tree[1] = in[2] & in[3];
    assign and_tree[2] = in[4] & in[5];
    assign and_tree[3] = in[6] & in[7];
    assign and_tree[4] = and_tree[0] & and_tree[1] & and_tree[2] & and_tree[3] & in[24:8];

    assign or_tree[0] = in[0] | in[1];
    assign or_tree[1] = in[2] | in[3];
    assign or_tree[2] = in[4] | in[5];
    assign or_tree[3] = in[6] | in[7];
    assign or_tree[4] = or_tree[0] | or_tree[1] | or_tree[2] | or_tree[3] | in[24:8];

    assign xor_tree[0] = in[0] ^ in[1];
    assign xor_tree[1] = in[2] ^ in[3];
    assign xor_tree[2] = in[4] ^ in[5];
    assign xor_tree[3] = in[6] ^ in[7];
    assign xor_tree[4] = xor_tree[0] ^ xor_tree[1] ^ xor_tree[2] ^ xor_tree[3] ^ in[24:8];

    assign and_out = and_tree[4];
    assign or_out = or_tree[4];
    assign xor_out = xor_tree[4];

endmodule