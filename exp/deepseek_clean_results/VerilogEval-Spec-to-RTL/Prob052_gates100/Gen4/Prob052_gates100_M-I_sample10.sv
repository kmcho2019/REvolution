module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Synthesis attribute to guide tool for optimal tree balancing
    (* parallel_case *) reg tmp_and;
    (* parallel_case *) reg tmp_or;

    // Hierarchical AND reduction using explicit parallel structure
    wire [6:0] and_tree;
    assign and_tree[0] = &in[15:0];
    assign and_tree[1] = &in[31:16];
    assign and_tree[2] = &in[47:32];
    assign and_tree[3] = &in[63:48];
    assign and_tree[4] = &in[79:64];
    assign and_tree[5] = &in[95:80];
    assign and_tree[6] = &in[99:96];
    assign out_and = &and_tree;

    // Hierarchical OR reduction using explicit parallel structure
    wire [6:0] or_tree;
    assign or_tree[0] = |in[15:0];
    assign or_tree[1] = |in[31:16];
    assign or_tree[2] = |in[47:32];
    assign or_tree[3] = |in[63:48];
    assign or_tree[4] = |in[79:64];
    assign or_tree[5] = |in[95:80];
    assign or_tree[6] = |in[99:96];
    assign out_or = |or_tree;

    // XOR remains optimal as reduction operator
    assign out_xor = ^in;

endmodule