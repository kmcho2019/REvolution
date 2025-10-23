module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Recursive binary tree mux structure
    wire [3:0] tree [0:7][0:255];  // 8 levels x up to 256 inputs
    
    // Level 0: Initial inputs (256 groups of 4 bits)
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_assign
            assign tree[0][i] = in[(i*4) +: 4];
        end
    endgenerate

    // Binary tree levels 1 through 7
    genvar level, idx;
    generate
        for (level = 1; level < 8; level = level + 1) begin : tree_levels
            for (idx = 0; idx < (256 >> level); idx = idx + 1) begin : tree_nodes
                assign tree[level][idx] = sel[level-1] ? 
                    tree[level-1][2*idx+1] : tree[level-1][2*idx];
            end
        end
    endgenerate

    // Final output is the root of the tree
    assign out = tree[7][0];

endmodule