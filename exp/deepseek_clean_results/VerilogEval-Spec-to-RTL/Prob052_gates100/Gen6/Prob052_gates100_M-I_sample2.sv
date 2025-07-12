module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Function to calculate tree levels needed
    function integer log2(input integer n);
        log2 = 0;
        while (n > 1) begin
            n = n >> 1;
            log2 = log2 + 1;
        end
    endfunction

    localparam LEVELS = log2(100) + 1;

    // AND tree implementation
    wire [99:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    genvar i, j;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : AND_TREE
            for (j = 0; j < (100 + (1 << i) - 1) / (1 << (i + 1)); j = j + 1) begin
                if (j*2 + 1 < (100 + (1 << i) - 1) / (1 << i)) begin
                    assign and_tree[i+1][j] = and_tree[i][j*2] & and_tree[i][j*2 + 1];
                end else begin
                    assign and_tree[i+1][j] = and_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_and = and_tree[LEVELS][0];

    // OR tree implementation
    wire [99:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : OR_TREE
            for (j = 0; j < (100 + (1 << i) - 1) / (1 << (i + 1)); j = j + 1) begin
                if (j*2 + 1 < (100 + (1 << i) - 1) / (1 << i)) begin
                    assign or_tree[i+1][j] = or_tree[i][j*2] | or_tree[i][j*2 + 1];
                end else begin
                    assign or_tree[i+1][j] = or_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_or = or_tree[LEVELS][0];

    // XOR tree implementation
    wire [99:0] xor_tree [0:LEVELS];
    assign xor_tree[0] = in;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : XOR_TREE
            for (j = 0; j < (100 + (1 << i) - 1) / (1 << (i + 1)); j = j + 1) begin
                if (j*2 + 1 < (100 + (1 << i) - 1) / (1 << i)) begin
                    assign xor_tree[i+1][j] = xor_tree[i][j*2] ^ xor_tree[i][j*2 + 1];
                end else begin
                    assign xor_tree[i+1][j] = xor_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_xor = xor_tree[LEVELS][0];

endmodule