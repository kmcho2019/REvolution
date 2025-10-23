module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree implementation for AND
    wire [24:0] and_l1;
    wire [5:0] and_l2;
    wire and_l3;
    
    genvar i;
    generate
        // Level 1: 25 groups of 4 bits
        for (i = 0; i < 25; i = i + 1) begin
            assign and_l1[i] = &in[i*4 +: 4];
        end
        
        // Level 2: 6 groups of 4 bits (plus 1 remaining)
        for (i = 0; i < 6; i = i + 1) begin
            assign and_l2[i] = &and_l1[i*4 +: 4];
        end
        
        // Final level
        assign and_l3 = &and_l1[24] & &and_l2[5:0];
    endgenerate
    
    assign out_and = and_l3;

    // Tree implementation for OR
    wire [24:0] or_l1;
    wire [5:0] or_l2;
    wire or_l3;
    
    generate
        // Level 1: 25 groups of 4 bits
        for (i = 0; i < 25; i = i + 1) begin
            assign or_l1[i] = |in[i*4 +: 4];
        end
        
        // Level 2: 6 groups of 4 bits (plus 1 remaining)
        for (i = 0; i < 6; i = i + 1) begin
            assign or_l2[i] = |or_l1[i*4 +: 4];
        end
        
        // Final level
        assign or_l3 = |or_l1[24] | |or_l2[5:0];
    endgenerate
    
    assign out_or = or_l3;

    // Tree implementation for XOR
    wire [24:0] xor_l1;
    wire [5:0] xor_l2;
    wire xor_l3;
    
    generate
        // Level 1: 25 groups of 4 bits
        for (i = 0; i < 25; i = i + 1) begin
            assign xor_l1[i] = ^in[i*4 +: 4];
        end
        
        // Level 2: 6 groups of 4 bits (plus 1 remaining)
        for (i = 0; i < 6; i = i + 1) begin
            assign xor_l2[i] = ^xor_l1[i*4 +: 4];
        end
        
        // Final level
        assign xor_l3 = xor_l1[24] ^ ^xor_l2[5:0];
    endgenerate
    
    assign out_xor = xor_l3;

endmodule