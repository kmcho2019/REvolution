module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameter for input width
    localparam WIDTH = 100;
    localparam TREE_LEVELS = $clog2(WIDTH);

    // Balanced tree reduction for AND and OR operations
    wire [WIDTH-1:0] tree [0:TREE_LEVELS];
    
    // Initialize leaf nodes
    assign tree[0] = in;
    
    // Build balanced binary tree
    generate
        for (genvar level = 0; level < TREE_LEVELS; level = level + 1) begin : tree_level
            for (genvar i = 0; i < (WIDTH >> (level + 1)); i = i + 1) begin : tree_node
                assign tree[level+1][i] = tree[level][2*i] & tree[level][2*i+1];
            end
            // Handle odd number of nodes at each level
            if (WIDTH >> (level + 1) != WIDTH >> level) begin
                assign tree[level+1][WIDTH >> (level + 1)] = tree[level][WIDTH >> level];
            end
        end
    endgenerate
    
    assign out_and = tree[TREE_LEVELS][0];
    
    // Reuse the same tree structure for OR operation
    wire [WIDTH-1:0] or_tree [0:TREE_LEVELS];
    
    assign or_tree[0] = in;
    
    generate
        for (genvar level = 0; level < TREE_LEVELS; level = level + 1) begin : or_tree_level
            for (genvar i = 0; i < (WIDTH >> (level + 1)); i = i + 1) begin : or_tree_node
                assign or_tree[level+1][i] = or_tree[level][2*i] | or_tree[level][2*i+1];
            end
            if (WIDTH >> (level + 1) != WIDTH >> level) begin
                assign or_tree[level+1][WIDTH >> (level + 1)] = or_tree[level][WIDTH >> level];
            end
        end
    endgenerate
    
    assign out_or = or_tree[TREE_LEVELS][0];
    
    // XOR operation remains optimal as reduction
    assign out_xor = ^in;

endmodule