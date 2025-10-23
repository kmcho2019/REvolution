module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree structure for AND operation
    wire [24:0] and_l1;
    wire [6:0] and_l2;
    wire [1:0] and_l3;
    
    // Level 1: 25 groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : AND_L1
            assign and_l1[i] = &in[i*4 +: 4];
        end
    endgenerate
    
    // Level 2: 7 groups (25 inputs)
    assign and_l2[0] = &and_l1[3:0];
    assign and_l2[1] = &and_l1[7:4];
    assign and_l2[2] = &and_l1[11:8];
    assign and_l2[3] = &and_l1[15:12];
    assign and_l2[4] = &and_l1[19:16];
    assign and_l2[5] = &and_l1[23:20];
    assign and_l2[6] = and_l1[24];
    
    // Level 3: 2 groups (7 inputs)
    assign and_l3[0] = &and_l2[2:0];
    assign and_l3[1] = &and_l2[6:3];
    
    // Final output
    assign out_and = &and_l3;

    // Tree structure for OR operation
    wire [24:0] or_l1;
    wire [6:0] or_l2;
    wire [1:0] or_l3;
    
    // Level 1: 25 groups of 4 bits
    genvar j;
    generate
        for (j = 0; j < 25; j = j + 1) begin : OR_L1
            assign or_l1[j] = |in[j*4 +: 4];
        end
    endgenerate
    
    // Level 2: 7 groups (25 inputs)
    assign or_l2[0] = |or_l1[3:0];
    assign or_l2[1] = |or_l1[7:4];
    assign or_l2[2] = |or_l1[11:8];
    assign or_l2[3] = |or_l1[15:12];
    assign or_l2[4] = |or_l1[19:16];
    assign or_l2[5] = |or_l1[23:20];
    assign or_l2[6] = or_l1[24];
    
    // Level 3: 2 groups (7 inputs)
    assign or_l3[0] = |or_l2[2:0];
    assign or_l3[1] = |or_l2[6:3];
    
    // Final output
    assign out_or = |or_l3;

    // Tree structure for XOR operation
    wire [24:0] xor_l1;
    wire [6:0] xor_l2;
    wire [1:0] xor_l3;
    
    // Level 1: 25 groups of 4 bits
    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : XOR_L1
            assign xor_l1[k] = ^in[k*4 +: 4];
        end
    endgenerate
    
    // Level 2: 7 groups (25 inputs)
    assign xor_l2[0] = ^xor_l1[3:0];
    assign xor_l2[1] = ^xor_l1[7:4];
    assign xor_l2[2] = ^xor_l1[11:8];
    assign xor_l2[3] = ^xor_l1[15:12];
    assign xor_l2[4] = ^xor_l1[19:16];
    assign xor_l2[5] = ^xor_l1[23:20];
    assign xor_l2[6] = xor_l1[24];
    
    // Level 3: 2 groups (7 inputs)
    assign xor_l3[0] = ^xor_l2[2:0];
    assign xor_l3[1] = ^xor_l2[6:3];
    
    // Final output
    assign out_xor = ^xor_l3;

endmodule