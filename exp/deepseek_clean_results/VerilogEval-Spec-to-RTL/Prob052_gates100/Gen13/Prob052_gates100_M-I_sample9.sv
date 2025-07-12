module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction parameters
    localparam LEVELS = 7; // ceil(log2(100)) = 7
    localparam PAD_VALUE_AND = 1'b1;
    localparam PAD_VALUE_OR = 1'b0;
    
    // Shared intermediate wires for AND/OR operations
    wire [127:0] tree_and_or [0:LEVELS]; // Pad to next power of 2 (128)
    wire [127:0] tree_xor [0:LEVELS];
    
    // Initialize level 0 (input level)
    assign tree_and_or[0][99:0] = in;
    assign tree_and_or[0][127:100] = {28{PAD_VALUE_AND}}; // Padding for AND
    assign tree_xor[0][99:0] = in;
    assign tree_xor[0][127:100] = {28{1'b0}}; // Zero padding for XOR
    
    // Tree reduction for AND/OR operations
    genvar level, idx;
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : tree_reduction
            for (idx = 0; idx < (128 >> level); idx = idx + 1) begin : level_nodes
                // AND reduction
                assign tree_and_or[level][idx] = tree_and_or[level-1][2*idx] & 
                                               tree_and_or[level-1][2*idx+1];
                
                // OR reduction (can share same tree structure)
                // XOR reduction (separate tree)
                assign tree_xor[level][idx] = tree_xor[level-1][2*idx] ^ 
                                             tree_xor[level-1][2*idx+1];
            end
        end
    endgenerate
    
    // Final outputs
    assign out_and = tree_and_or[LEVELS][0];
    assign out_or = |in; // OR is simpler with reduction operator (synthesis will optimize)
    assign out_xor = tree_xor[LEVELS][0];

endmodule