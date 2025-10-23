module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate AND results (10 groups of 10 bits)
    wire [9:0] and_stage1;
    // Intermediate OR results (10 groups of 10 bits)
    wire [9:0] or_stage1;
    
    // First stage: Process 10 groups of 10 bits
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1
            assign and_stage1[i] = &in[i*10 +: 10];
            assign or_stage1[i]  = |in[i*10 +: 10];
        end
    endgenerate
    
    // Second stage: Combine 10 intermediate results
    assign out_and = &and_stage1;
    assign out_or  = |or_stage1;
    
    // XOR implemented as balanced binary tree
    wire [49:0] xor_tree [0:6]; // 6 levels for 100 inputs
    
    // Initialize leaves
    assign xor_tree[0] = in;
    
    // Build XOR tree
    generate
        for (i = 1; i <= 6; i = i + 1) begin : xor_tree_gen
            integer j;
            always @(*) begin
                for (j = 0; j < (100 >> i); j = j + 1) begin
                    if ((j*2+1) < (100 >> (i-1))) begin
                        xor_tree[i][j] = xor_tree[i-1][j*2] ^ xor_tree[i-1][j*2+1];
                    end else begin
                        xor_tree[i][j] = xor_tree[i-1][j*2];
                    end
                end
            end
        end
    endgenerate
    
    assign out_xor = xor_tree[6][0];

endmodule