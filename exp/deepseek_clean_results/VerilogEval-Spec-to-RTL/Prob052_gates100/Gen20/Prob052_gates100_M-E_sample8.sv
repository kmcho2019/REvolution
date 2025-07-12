module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction parameters
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);

    // AND tree reduction
    wire [WIDTH-1:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    
    genvar i;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : and_tree_gen
            for (genvar j = 0; j < (WIDTH >> (i+1)); j = j + 1) begin
                assign and_tree[i+1][j] = and_tree[i][2*j] & and_tree[i][2*j+1];
            end
            // Handle odd number of inputs at each level
            if (WIDTH >> (i+1) * 2 != WIDTH >> i) begin
                assign and_tree[i+1][WIDTH >> (i+1)] = and_tree[i][(WIDTH >> i) - 1];
            end
        end
    endgenerate
    assign out_and = and_tree[LEVELS][0];

    // OR tree reduction
    wire [WIDTH-1:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    
    genvar k;
    generate
        for (k = 0; k < LEVELS; k = k + 1) begin : or_tree_gen
            for (genvar l = 0; l < (WIDTH >> (k+1)); l = l + 1) begin
                assign or_tree[k+1][l] = or_tree[k][2*l] | or_tree[k][2*l+1];
            end
            if (WIDTH >> (k+1) * 2 != WIDTH >> k) begin
                assign or_tree[k+1][WIDTH >> (k+1)] = or_tree[k][(WIDTH >> k) - 1];
            end
        end
    endgenerate
    assign out_or = or_tree[LEVELS][0];

    // XOR tree reduction (parity calculation)
    wire [WIDTH-1:0] xor_tree [0:LEVELS];
    assign xor_tree[0] = in;
    
    genvar m;
    generate
        for (m = 0; m < LEVELS; m = m + 1) begin : xor_tree_gen
            for (genvar n = 0; n < (WIDTH >> (m+1)); n = n + 1) begin
                assign xor_tree[m+1][n] = xor_tree[m][2*n] ^ xor_tree[m][2*n+1];
            end
            if (WIDTH >> (m+1) * 2 != WIDTH >> m) begin
                assign xor_tree[m+1][WIDTH >> (m+1)] = xor_tree[m][(WIDTH >> m) - 1];
            end
        end
    endgenerate
    assign out_xor = xor_tree[LEVELS][0];

endmodule