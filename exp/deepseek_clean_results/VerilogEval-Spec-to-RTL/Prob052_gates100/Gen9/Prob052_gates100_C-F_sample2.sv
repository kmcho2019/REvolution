module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree-structured AND reduction
    wire [6:0][99:0] and_tree;
    assign and_tree[0] = in;
    genvar i, j;
    generate
        for (i = 1; i <= 6; i = i + 1) begin : AND_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : AND_LEVEL
                assign and_tree[i][j] = and_tree[i-1][2*j] & and_tree[i-1][2*j+1];
            end
            // Handle odd number of inputs at each level
            if ((100 >> (i-1)) % 2) begin
                assign and_tree[i][(100 >> i)] = and_tree[i-1][100 >> (i-1) * 2];
            end
        end
    endgenerate
    assign out_and = and_tree[6][0];

    // Tree-structured OR reduction
    wire [6:0][99:0] or_tree;
    assign or_tree[0] = in;
    generate
        for (i = 1; i <= 6; i = i + 1) begin : OR_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : OR_LEVEL
                assign or_tree[i][j] = or_tree[i-1][2*j] | or_tree[i-1][2*j+1];
            end
            // Handle odd number of inputs at each level
            if ((100 >> (i-1)) % 2) begin
                assign or_tree[i][(100 >> i)] = or_tree[i-1][100 >> (i-1) * 2];
            end
        end
    endgenerate
    assign out_or = or_tree[6][0];

    // Tree-structured XOR reduction
    wire [6:0][99:0] xor_tree;
    assign xor_tree[0] = in;
    generate
        for (i = 1; i <= 6; i = i + 1) begin : XOR_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : XOR_LEVEL
                assign xor_tree[i][j] = xor_tree[i-1][2*j] ^ xor_tree[i-1][2*j+1];
            end
            // Handle odd number of inputs at each level
            if ((100 >> (i-1)) % 2) begin
                assign xor_tree[i][(100 >> i)] = xor_tree[i-1][100 >> (i-1) * 2];
            end
        end
    endgenerate
    assign out_xor = xor_tree[6][0];

endmodule