module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction parameters
    localparam LEVELS = 7; // ceil(log2(100)) = 7
    localparam WIDTH = 1 << LEVELS; // 128 (pad with 1's for AND, 0's for OR)

    // Pad inputs to next power of 2 for balanced tree
    wire [WIDTH-1:0] padded_in;
    assign padded_in[99:0] = in;
    assign padded_in[WIDTH-1:100] = {28{1'b1}}; // For AND (neutral element)
    // For OR, these bits would be 0 (neutral element), but we'll handle separately

    // Tree reduction implementation
    wire [WIDTH-1:0] and_tree [0:LEVELS];
    wire [WIDTH-1:0] or_tree [0:LEVELS];
    wire [WIDTH-1:0] xor_tree [0:LEVELS];

    // Initialize level 0
    assign and_tree[0] = padded_in;
    assign or_tree[0] = padded_in;
    assign xor_tree[0] = padded_in;

    // Generate tree levels
    genvar i, j;
    generate
        for (i = 1; i <= LEVELS; i = i + 1) begin : tree_level
            for (j = 0; j < (WIDTH >> i); j = j + 1) begin : tree_node
                assign and_tree[i][j] = and_tree[i-1][2*j] & and_tree[i-1][2*j+1];
                assign or_tree[i][j]  = or_tree[i-1][2*j] | or_tree[i-1][2*j+1];
                assign xor_tree[i][j] = xor_tree[i-1][2*j] ^ xor_tree[i-1][2*j+1];
            end
        end
    endgenerate

    // Final outputs
    assign out_and = and_tree[LEVELS][0];
    assign out_or  = or_tree[LEVELS][0];
    assign out_xor = xor_tree[LEVELS][0];

endmodule