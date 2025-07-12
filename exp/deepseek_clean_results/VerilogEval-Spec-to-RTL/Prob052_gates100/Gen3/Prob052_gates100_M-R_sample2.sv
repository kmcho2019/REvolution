module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for tree structure
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);

    // AND tree implementation
    wire [WIDTH-1:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    genvar i, j;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : AND_TREE
            for (j = 0; j < (WIDTH+(1<<i)-1)/(1<<(i+1)); j = j + 1) begin : AND_LEVEL
                if (j*2+1 < (WIDTH+(1<<i)-1)/(1<<i)) begin
                    assign and_tree[i+1][j] = and_tree[i][j*2] & and_tree[i][j*2+1];
                end else begin
                    assign and_tree[i+1][j] = and_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_and = and_tree[LEVELS][0];

    // OR tree implementation
    wire [WIDTH-1:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    genvar k, l;
    generate
        for (k = 0; k < LEVELS; k = k + 1) begin : OR_TREE
            for (l = 0; l < (WIDTH+(1<<k)-1)/(1<<(k+1)); l = l + 1) begin : OR_LEVEL
                if (l*2+1 < (WIDTH+(1<<k)-1)/(1<<k)) begin
                    assign or_tree[k+1][l] = or_tree[k][l*2] | or_tree[k][l*2+1];
                end else begin
                    assign or_tree[k+1][l] = or_tree[k][l*2];
                end
            end
        end
    endgenerate
    assign out_or = or_tree[LEVELS][0];

    // XOR tree implementation
    wire [WIDTH-1:0] xor_tree [0:LEVELS];
    assign xor_tree[0] = in;
    genvar m, n;
    generate
        for (m = 0; m < LEVELS; m = m + 1) begin : XOR_TREE
            for (n = 0; n < (WIDTH+(1<<m)-1)/(1<<(m+1)); n = n + 1) begin : XOR_LEVEL
                if (n*2+1 < (WIDTH+(1<<m)-1)/(1<<m)) begin
                    assign xor_tree[m+1][n] = xor_tree[m][n*2] ^ xor_tree[m][n*2+1];
                end else begin
                    assign xor_tree[m+1][n] = xor_tree[m][n*2];
                end
            end
        end
    endgenerate
    assign out_xor = xor_tree[LEVELS][0];

endmodule