module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Function to calculate tree levels needed
    function integer log2(input integer n);
        log2 = 0;
        while (2**log2 < n) log2 = log2 + 1;
    endfunction

    localparam LEVELS = log2(100);

    // AND Tree implementation
    wire [99:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    genvar i;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : AND_TREE
            integer j;
            always @(*) begin
                for (j = 0; j < (100 + (1<<i) - 1)/(1<<(i+1)); j = j + 1) begin
                    if (j*2 + 1 < (100 + (1<<i) - 1)/(1<<i))
                        and_tree[i+1][j] = and_tree[i][j*2] & and_tree[i][j*2 + 1];
                    else
                        and_tree[i+1][j] = and_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_and = and_tree[LEVELS][0];

    // OR Tree implementation
    wire [99:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    genvar k;
    generate
        for (k = 0; k < LEVELS; k = k + 1) begin : OR_TREE
            integer l;
            always @(*) begin
                for (l = 0; l < (100 + (1<<k) - 1)/(1<<(k+1)); l = l + 1) begin
                    if (l*2 + 1 < (100 + (1<<k) - 1)/(1<<k))
                        or_tree[k+1][l] = or_tree[k][l*2] | or_tree[k][l*2 + 1];
                    else
                        or_tree[k+1][l] = or_tree[k][l*2];
                end
            end
        end
    endgenerate
    assign out_or = or_tree[LEVELS][0];

    // XOR Tree implementation
    wire [99:0] xor_tree [0:LEVELS];
    assign xor_tree[0] = in;
    genvar m;
    generate
        for (m = 0; m < LEVELS; m = m + 1) begin : XOR_TREE
            integer n;
            always @(*) begin
                for (n = 0; n < (100 + (1<<m) - 1)/(1<<(m+1)); n = n + 1) begin
                    if (n*2 + 1 < (100 + (1<<m) - 1)/(1<<m))
                        xor_tree[m+1][n] = xor_tree[m][n*2] ^ xor_tree[m][n*2 + 1];
                    else
                        xor_tree[m+1][n] = xor_tree[m][n*2];
                end
            end
        end
    endgenerate
    assign out_xor = xor_tree[LEVELS][0];

endmodule