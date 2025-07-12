module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Create 8 levels of 4-bit wires (level 0 is input, level 8 is output)
    wire [3:0] tree [0:7][0:255];  // [level][node]

    // Initialize level 0 with all input bits
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : init_level
            assign tree[0][i] = in[(i*4) +: 4];
        end
    endgenerate

    // Build the binary tree
    genvar level, node;
    generate
        for (level = 1; level <= 7; level = level + 1) begin : tree_levels
            for (node = 0; node < (256 >> level); node = node + 1) begin : tree_nodes
                assign tree[level][node] = sel[7-level+1] ? 
                                         tree[level-1][node*2 + 1] : 
                                         tree[level-1][node*2];
            end
        end
    endgenerate

    // Final output is the root of the tree
    assign out = tree[7][0];

endmodule