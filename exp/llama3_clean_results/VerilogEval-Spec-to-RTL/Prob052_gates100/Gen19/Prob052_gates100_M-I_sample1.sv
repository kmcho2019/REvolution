module TreeOperation(
    input  [99:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    wire [49:0] and_tree;
    assign and_tree[0] = in[0];
    for (genvar i = 1; i < 50; i++) begin
        assign and_tree[i] = in[i] & and_tree[i-1];
    end
    assign and_out = and_tree[49];

    // OR Operation
    wire [49:0] or_tree;
    assign or_tree[0] = in[0];
    for (genvar i = 1; i < 50; i++) begin
        assign or_tree[i] = in[i] | or_tree[i-1];
    end
    assign or_out = or_tree[49];

    // XOR Operation
    wire [49:0] xor_tree;
    assign xor_tree[0] = in[0];
    for (genvar i = 1; i < 50; i++) begin
        assign xor_tree[i] = in[i] ^ xor_tree[i-1];
    end
    assign xor_out = xor_tree[49];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    TreeOperation tree_op(.in(in), .and_out(out_and), .or_out(out_or), .xor_out(out_xor));

endmodule