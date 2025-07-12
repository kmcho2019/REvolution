module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Shared parameters
    localparam WIDTH = 100;
    localparam TREE_LEVELS = $clog2(WIDTH);

    // Binary tree reduction for AND/OR with early termination
    wire [WIDTH-1:0] and_tree [0:TREE_LEVELS];
    wire [WIDTH-1:0] or_tree [0:TREE_LEVELS];
    
    // Initialize leaves
    assign and_tree[0] = in;
    assign or_tree[0] = in;
    
    // Build reduction trees
    genvar level, idx;
    generate
        for (level = 1; level <= TREE_LEVELS; level = level + 1) begin : tree_level
            for (idx = 0; idx < (WIDTH >> level); idx = idx + 1) begin : tree_node
                // AND tree with early termination propagation
                assign and_tree[level][idx] = (and_tree[level-1][2*idx] == 1'b0 || 
                                             and_tree[level-1][2*idx+1] == 1'b0) ? 
                                             1'b0 : 
                                             (and_tree[level-1][2*idx] & and_tree[level-1][2*idx+1]);
                
                // OR tree with early termination propagation
                assign or_tree[level][idx] = (or_tree[level-1][2*idx] == 1'b1 || 
                                            or_tree[level-1][2*idx+1] == 1'b1) ? 
                                            1'b1 : 
                                            (or_tree[level-1][2*idx] | or_tree[level-1][2*idx+1]);
            end
            
            // Handle odd number of inputs at each level
            if (WIDTH >> (level-1) != 2*(WIDTH >> level)) begin : odd_inputs
                assign and_tree[level][WIDTH >> level] = and_tree[level-1][WIDTH >> (level-1)];
                assign or_tree[level][WIDTH >> level] = or_tree[level-1][WIDTH >> (level-1)];
            end
        end
    endgenerate
    
    assign out_and = and_tree[TREE_LEVELS][0];
    assign out_or = or_tree[TREE_LEVELS][0];

    // Optimized XOR (parity) tree
    wire [WIDTH-1:0] xor_tree [0:TREE_LEVELS];
    assign xor_tree[0] = in;
    
    generate
        for (level = 1; level <= TREE_LEVELS; level = level + 1) begin : xor_level
            for (idx = 0; idx < (WIDTH >> level); idx = idx + 1) begin : xor_node
                assign xor_tree[level][idx] = xor_tree[level-1][2*idx] ^ xor_tree[level-1][2*idx+1];
            end
            
            if (WIDTH >> (level-1) != 2*(WIDTH >> level)) begin : xor_odd
                assign xor_tree[level][WIDTH >> level] = xor_tree[level-1][WIDTH >> (level-1)];
            end
        end
    endgenerate
    
    assign out_xor = xor_tree[TREE_LEVELS][0];

endmodule