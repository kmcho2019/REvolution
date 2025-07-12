module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate results for AND tree
    wire [24:0] and_level1;
    wire [5:0] and_level2;
    wire [1:0] and_level3;
    
    // Intermediate results for OR tree
    wire [24:0] or_level1;
    wire [5:0] or_level2;
    wire [1:0] or_level3;
    
    // Intermediate results for XOR tree
    wire [24:0] xor_level1;
    wire [5:0] xor_level2;
    wire [1:0] xor_level3;
    
    // First level: Process 4-bit groups
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : level1
            if (i < 25) begin
                assign and_level1[i] = &in[i*4 +: 4];
                assign or_level1[i]  = |in[i*4 +: 4];
                assign xor_level1[i] = ^in[i*4 +: 4];
            end
        end
    endgenerate
    
    // Second level: Combine 25 inputs into 6 groups
    assign and_level2[0] = &and_level1[3:0];
    assign and_level2[1] = &and_level1[7:4];
    assign and_level2[2] = &and_level1[11:8];
    assign and_level2[3] = &and_level1[15:12];
    assign and_level2[4] = &and_level1[19:16];
    assign and_level2[5] = &and_level1[23:20];
    
    assign or_level2[0] = |or_level1[3:0];
    assign or_level2[1] = |or_level1[7:4];
    assign or_level2[2] = |or_level1[11:8];
    assign or_level2[3] = |or_level1[15:12];
    assign or_level2[4] = |or_level1[19:16];
    assign or_level2[5] = |or_level1[23:20];
    
    assign xor_level2[0] = ^xor_level1[3:0];
    assign xor_level2[1] = ^xor_level1[7:4];
    assign xor_level2[2] = ^xor_level1[11:8];
    assign xor_level2[3] = ^xor_level1[15:12];
    assign xor_level2[4] = ^xor_level1[19:16];
    assign xor_level2[5] = ^xor_level1[23:20];
    
    // Handle remaining input (24-25)
    wire and_remaining = &and_level1[24];
    wire or_remaining  = |or_level1[24];
    wire xor_remaining = xor_level1[24];
    
    // Third level: Combine 6 groups + remaining
    assign and_level3[0] = &and_level2[2:0];
    assign and_level3[1] = &and_level2[5:3];
    
    assign or_level3[0] = |or_level2[2:0];
    assign or_level3[1] = |or_level2[5:3];
    
    assign xor_level3[0] = ^xor_level2[2:0];
    assign xor_level3[1] = ^xor_level2[5:3];
    
    // Final outputs
    assign out_and = &{and_level3, and_remaining};
    assign out_or  = |{or_level3, or_remaining};
    assign out_xor = ^{xor_level3, xor_remaining};

endmodule