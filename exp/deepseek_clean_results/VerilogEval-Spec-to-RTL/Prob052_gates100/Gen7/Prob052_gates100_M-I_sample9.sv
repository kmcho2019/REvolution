module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree parameters
    localparam LEVELS = 7;
    
    // AND tree implementation
    wire [99:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    genvar i, j;
    generate
        for (i = 1; i <= LEVELS; i = i + 1) begin : AND_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : AND_NODES
                assign and_tree[i][j] = and_tree[i-1][2*j] & and_tree[i-1][2*j+1];
            end
            // Handle odd number of inputs at each level
            if (100 >> (i-1) != 2*(100 >> i)) begin : AND_ODD
                assign and_tree[i][100 >> i] = and_tree[i-1][2*(100 >> i)];
            end
        end
    endgenerate
    assign out_and = &and_tree[LEVELS][0];

    // OR tree implementation
    wire [99:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    generate
        for (i = 1; i <= LEVELS; i = i + 1) begin : OR_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : OR_NODES
                assign or_tree[i][j] = or_tree[i-1][2*j] | or_tree[i-1][2*j+1];
            end
            if (100 >> (i-1) != 2*(100 >> i)) begin : OR_ODD
                assign or_tree[i][100 >> i] = or_tree[i-1][2*(100 >> i)];
            end
        end
    endgenerate
    assign out_or = |or_tree[LEVELS][0];

    // XOR tree implementation
    wire [99:0] xor_tree [0:LEVELS];
    assign xor_tree[0] = in;
    generate
        for (i = 1; i <= LEVELS; i = i + 1) begin : XOR_TREE
            for (j = 0; j < (100 >> i); j = j + 1) begin : XOR_NODES
                assign xor_tree[i][j] = xor_tree[i-1][2*j] ^ xor_tree[i-1][2*j+1];
            end
            if (100 >> (i-1) != 2*(100 >> i)) begin : XOR_ODD
                assign xor_tree[i][100 >> i] = xor_tree[i-1][2*(100 >> i)];
            end
        end
    endgenerate
    assign out_xor = ^xor_tree[LEVELS][0];

endmodule