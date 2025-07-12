module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Optimal AND/OR using reduction operators
    assign out_and = &in;
    assign out_or  = |in;

    // Optimized XOR using balanced tree structure
    wire [24:0] xor_l1;
    wire [4:0]  xor_l2;
    wire        xor_l3;

    // Level 1: 25 parallel 4-bit XORs
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : XOR_L1
            assign xor_l1[i] = ^in[i*4 +: 4];
        end
    endgenerate

    // Level 2: 5 parallel 5-bit XORs
    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : XOR_L2
            assign xor_l2[j] = ^xor_l1[j*5 +: 5];
        end
    endgenerate

    // Final XOR
    assign out_xor = ^xor_l2;

endmodule