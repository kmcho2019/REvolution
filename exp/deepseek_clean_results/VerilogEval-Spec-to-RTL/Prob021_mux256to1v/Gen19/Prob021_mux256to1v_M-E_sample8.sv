module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Binary tree implementation with 8 levels
    wire [3:0] tree [0:7][0:255];  // 8 levels, 256->128->64->...->1

    // Initialize leaf nodes (level 0)
    generate
        for (genvar i = 0; i < 256; i = i + 1) begin : init_leaves
            assign tree[0][i] = in[(i*4) +: 4];
        end
    endgenerate

    // Build the binary tree
    generate
        for (genvar level = 1; level < 8; level = level + 1) begin : build_tree
            for (genvar node = 0; node < (256 >> level); node = node + 1) begin : level_nodes
                assign tree[level][node] = sel[level-1] ? 
                                          tree[level-1][(node<<1)+1] : 
                                          tree[level-1][node<<1];
            end
        end
    endgenerate

    // Final output is the root of the tree
    assign out = tree[7][0];

endmodule