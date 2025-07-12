module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Use built-in reduction operators for AND and OR - synthesis tools will optimize these
    assign out_and = &in;
    assign out_or = |in;

    // Implement XOR using a balanced binary tree for optimal timing
    // Tree parameters for 100 inputs (7 levels needed)
    localparam LEVELS = 7;
    
    // Create a parameterized XOR tree
    wire [99:0] xor_tree [0:LEVELS];
    
    // Initialize level 0 with input
    assign xor_tree[0] = in;
    
    genvar level, idx;
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : xor_tree_level
            for (idx = 0; idx < (100 + (1 << level) - 1) / (1 << level); idx = idx + 1) begin : xor_nodes
                if (idx*2+1 < (100 + (1 << (level-1)) - 1) / (1 << (level-1))) begin
                    // Normal case: both children exist
                    assign xor_tree[level][idx] = xor_tree[level-1][idx*2] ^ xor_tree[level-1][idx*2+1];
                end else begin
                    // Last node case: might have only one child
                    assign xor_tree[level][idx] = xor_tree[level-1][idx*2];
                end
            end
        end
    endgenerate
    
    // Final XOR output
    assign out_xor = xor_tree[LEVELS][0];

endmodule