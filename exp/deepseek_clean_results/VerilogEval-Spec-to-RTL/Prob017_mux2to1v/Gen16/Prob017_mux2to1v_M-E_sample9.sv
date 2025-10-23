module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Tree parameters
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);
    
    // Create a multi-dimensional array for the tree
    wire [WIDTH-1:0] tree [0:LEVELS];
    
    // Initialize leaves
    assign tree[0] = sel ? b : a;
    
    // Build the reduction tree
    genvar level, bit;
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : tree_level
            for (bit = 0; bit < WIDTH; bit = bit + 1) begin : tree_bit
                // Each level reduces by selecting every other bit from previous level
                if (bit % (2**level) < (2**(level-1))) begin
                    assign tree[level][bit] = tree[level-1][bit];
                end else begin
                    assign tree[level][bit] = tree[level-1][bit - (2**(level-1))];
                end
            end
        end
    endgenerate
    
    // Final output is the root of the tree
    assign out = tree[LEVELS];

endmodule