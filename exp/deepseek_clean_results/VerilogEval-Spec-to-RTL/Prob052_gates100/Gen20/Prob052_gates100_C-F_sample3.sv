module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Binary tree reduction for AND operation
    wire [6:0][99:0] and_tree;
    assign and_tree[0] = in;
    
    genvar i;
    generate
        for (i = 1; i <= 6; i = i + 1) begin : AND_TREE
            for (genvar j = 0; j < 100/(2**i); j = j + 1) begin
                assign and_tree[i][j] = and_tree[i-1][2*j] & and_tree[i-1][2*j+1];
            end
            // Handle odd number of inputs at each level
            if (100 % (2**i) != 0) begin
                assign and_tree[i][100/(2**i)] = and_tree[i-1][100/(2**i)*2];
            end
        end
    endgenerate
    assign out_and = and_tree[6][0];

    // Binary tree reduction for OR operation
    wire [6:0][99:0] or_tree;
    assign or_tree[0] = in;
    
    genvar k;
    generate
        for (k = 1; k <= 6; k = k + 1) begin : OR_TREE
            for (genvar l = 0; l < 100/(2**k); l = l + 1) begin
                assign or_tree[k][l] = or_tree[k-1][2*l] | or_tree[k-1][2*l+1];
            end
            if (100 % (2**k) != 0) begin
                assign or_tree[k][100/(2**k)] = or_tree[k-1][100/(2**k)*2];
            end
        end
    endgenerate
    assign out_or = or_tree[6][0];

    // Binary tree reduction for XOR operation
    wire [6:0][99:0] xor_tree;
    assign xor_tree[0] = in;
    
    genvar m;
    generate
        for (m = 1; m <= 6; m = m + 1) begin : XOR_TREE
            for (genvar n = 0; n < 100/(2**m); n = n + 1) begin
                assign xor_tree[m][n] = xor_tree[m-1][2*n] ^ xor_tree[m-1][2*n+1];
            end
            if (100 % (2**m) != 0) begin
                assign xor_tree[m][100/(2**m)] = xor_tree[m-1][100/(2**m)*2];
            end
        end
    endgenerate
    assign out_xor = xor_tree[6][0];

endmodule