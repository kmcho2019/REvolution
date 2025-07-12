module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Function to calculate tree levels needed for 100 inputs
    // ceil(log2(100)) = 7 levels

    // AND Tree Implementation
    wire [126:0] and_tree; // 1+2+4+8+16+32+64 = 127 nodes (7 levels)
    
    // Level 0: Leaves (100 inputs)
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : AND_LEAVES
            assign and_tree[i] = in[i];
        end
        // Pad with 1's for incomplete groups
        for (i = 100; i < 128; i = i + 1) begin : AND_PAD
            assign and_tree[i] = 1'b1;
        end
    endgenerate
    
    // Tree levels 1-6
    generate
        for (i = 0; i < 63; i = i + 1) begin : AND_NODES
            assign and_tree[64 + i] = and_tree[2*i] & and_tree[2*i + 1];
        end
    endgenerate
    
    assign out_and = and_tree[126]; // Root of the tree

    // OR Tree Implementation
    wire [126:0] or_tree;
    
    // Level 0: Leaves
    generate
        for (i = 0; i < 100; i = i + 1) begin : OR_LEAVES
            assign or_tree[i] = in[i];
        end
        // Pad with 0's for incomplete groups
        for (i = 100; i < 128; i = i + 1) begin : OR_PAD
            assign or_tree[i] = 1'b0;
        end
    endgenerate
    
    // Tree levels 1-6
    generate
        for (i = 0; i < 63; i = i + 1) begin : OR_NODES
            assign or_tree[64 + i] = or_tree[2*i] | or_tree[2*i + 1];
        end
    endgenerate
    
    assign out_or = or_tree[126]; // Root of the tree

    // XOR Tree Implementation
    wire [126:0] xor_tree;
    
    // Level 0: Leaves
    generate
        for (i = 0; i < 100; i = i + 1) begin : XOR_LEAVES
            assign xor_tree[i] = in[i];
        end
        // Pad with 0's for incomplete groups
        for (i = 100; i < 128; i = i + 1) begin : XOR_PAD
            assign xor_tree[i] = 1'b0;
        end
    endgenerate
    
    // Tree levels 1-6
    generate
        for (i = 0; i < 63; i = i + 1) begin : XOR_NODES
            assign xor_tree[64 + i] = xor_tree[2*i] ^ xor_tree[2*i + 1];
        end
    endgenerate
    
    assign out_xor = xor_tree[126]; // Root of the tree

endmodule