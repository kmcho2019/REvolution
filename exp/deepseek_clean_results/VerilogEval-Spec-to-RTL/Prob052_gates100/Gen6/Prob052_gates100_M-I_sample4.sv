module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Maintain optimal AND/OR implementations
    assign out_and = &in;
    assign out_or  = |in;
    
    // Optimized XOR using balanced tree structure
    wire [24:0] xor_l1;
    wire [5:0] xor_l2;
    wire [1:0] xor_l3;
    
    // Level 1: 25 groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin
            assign xor_l1[i] = ^in[i*4 +: 4];
        end
    endgenerate
    
    // Level 2: 6 groups of 4 bits + remaining
    assign xor_l2[0] = ^xor_l1[3:0];
    assign xor_l2[1] = ^xor_l1[7:4];
    assign xor_l2[2] = ^xor_l1[11:8];
    assign xor_l2[3] = ^xor_l1[15:12];
    assign xor_l2[4] = ^xor_l1[19:16];
    assign xor_l2[5] = ^xor_l1[24:20]; // 5 bits
    
    // Level 3: Final reduction
    assign xor_l3[0] = ^xor_l2[2:0];
    assign xor_l3[1] = ^xor_l2[5:3];
    
    // Output
    assign out_xor = ^xor_l3;

endmodule