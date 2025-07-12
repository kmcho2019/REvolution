module TreeOperation(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND Operation
    wire [9:0] and_tree;
    assign and_tree[0] = in[0] & in[1];
    assign and_tree[1] = in[2] & in[3];
    assign and_tree[2] = in[4] & in[5];
    assign and_tree[3] = in[6] & in[7];
    assign and_tree[4] = in[8] & in[9];
    assign and_tree[5] = in[10] & in[11];
    assign and_tree[6] = in[12] & in[13];
    assign and_tree[7] = in[14] & in[15];
    assign and_tree[8] = in[16] & in[17];
    assign and_tree[9] = in[18] & in[19];
    wire [4:0] and_tree2;
    assign and_tree2[0] = and_tree[0] & and_tree[1];
    assign and_tree2[1] = and_tree[2] & and_tree[3];
    assign and_tree2[2] = and_tree[4] & and_tree[5];
    assign and_tree2[3] = and_tree[6] & and_tree[7];
    assign and_tree2[4] = and_tree[8] & and_tree[9];
    wire [1:0] and_tree3;
    assign and_tree3[0] = and_tree2[0] & and_tree2[1];
    assign and_tree3[1] = and_tree2[2] & and_tree2[3];
    assign out_and = and_tree3[0] & and_tree3[1] & and_tree2[4];

    // OR Operation
    wire [9:0] or_tree;
    assign or_tree[0] = in[0] | in[1];
    assign or_tree[1] = in[2] | in[3];
    assign or_tree[2] = in[4] | in[5];
    assign or_tree[3] = in[6] | in[7];
    assign or_tree[4] = in[8] | in[9];
    assign or_tree[5] = in[10] | in[11];
    assign or_tree[6] = in[12] | in[13];
    assign or_tree[7] = in[14] | in[15];
    assign or_tree[8] = in[16] | in[17];
    assign or_tree[9] = in[18] | in[19];
    wire [4:0] or_tree2;
    assign or_tree2[0] = or_tree[0] | or_tree[1];
    assign or_tree2[1] = or_tree[2] | or_tree[3];
    assign or_tree2[2] = or_tree[4] | or_tree[5];
    assign or_tree2[3] = or_tree[6] | or_tree[7];
    assign or_tree2[4] = or_tree[8] | or_tree[9];
    wire [1:0] or_tree3;
    assign or_tree3[0] = or_tree2[0] | or_tree2[1];
    assign or_tree3[1] = or_tree2[2] | or_tree2[3];
    assign out_or = or_tree3[0] | or_tree3[1] | or_tree2[4];

    // XOR Operation
    wire [9:0] xor_tree;
    assign xor_tree[0] = in[0] ^ in[1];
    assign xor_tree[1] = in[2] ^ in[3];
    assign xor_tree[2] = in[4] ^ in[5];
    assign xor_tree[3] = in[6] ^ in[7];
    assign xor_tree[4] = in[8] ^ in[9];
    assign xor_tree[5] = in[10] ^ in[11];
    assign xor_tree[6] = in[12] ^ in[13];
    assign xor_tree[7] = in[14] ^ in[15];
    assign xor_tree[8] = in[16] ^ in[17];
    assign xor_tree[9] = in[18] ^ in[19];
    wire [4:0] xor_tree2;
    assign xor_tree2[0] = xor_tree[0] ^ xor_tree[1];
    assign xor_tree2[1] = xor_tree[2] ^ xor_tree[3];
    assign xor_tree2[2] = xor_tree[4] ^ xor_tree[5];
    assign xor_tree2[3] = xor_tree[6] ^ xor_tree[7];
    assign xor_tree2[4] = xor_tree[8] ^ xor_tree[9];
    wire [1:0] xor_tree3;
    assign xor_tree3[0] = xor_tree2[0] ^ xor_tree2[1];
    assign xor_tree3[1] = xor_tree2[2] ^ xor_tree2[3];
    assign out_xor = xor_tree3[0] ^ xor_tree3[1] ^ xor_tree2[4];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    TreeOperation tree_op(.in(in), .out_and(out_and), .out_or(out_or), .out_xor(out_xor));

endmodule