module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    localparam WIDTH = 100;
    localparam TREE_LEVELS = 7; // 2^7 = 128 > 100

    // Binary tree reduction for AND
    wire [127:0] and_tree [TREE_LEVELS:0]; // Extra bits for balanced tree
    assign and_tree[0][99:0] = in;
    assign and_tree[0][127:100] = {28{1'b1}}; // Pad with 1's for AND

    generate
        for (genvar level = 1; level <= TREE_LEVELS; level = level + 1) begin : and_tree_gen
            for (genvar i = 0; i < (128 >> level); i = i + 1) begin
                assign and_tree[level][i] = and_tree[level-1][2*i] & and_tree[level-1][2*i+1];
            end
        end
    endgenerate
    assign out_and = and_tree[TREE_LEVELS][0];

    // Binary tree reduction for OR
    wire [127:0] or_tree [TREE_LEVELS:0];
    assign or_tree[0][99:0] = in;
    assign or_tree[0][127:100] = {28{1'b0}}; // Pad with 0's for OR

    generate
        for (genvar level = 1; level <= TREE_LEVELS; level = level + 1) begin : or_tree_gen
            for (genvar i = 0; i < (128 >> level); i = i + 1) begin
                assign or_tree[level][i] = or_tree[level-1][2*i] | or_tree[level-1][2*i+1];
            end
        end
    endgenerate
    assign out_or = or_tree[TREE_LEVELS][0];

    // XOR using reduction operator (optimal implementation)
    assign out_xor = ^in;

endmodule