module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // First-level partial reductions: 10 groups of 10 bits each using reduction operators
    wire [9:0] and_lvl1;
    wire [9:0] or_lvl1;
    wire [9:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : level1_reduce
            assign and_lvl1[i] = &in[i*10 +: 10];
            assign or_lvl1[i]  = |in[i*10 +: 10];
            assign xor_lvl1[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Function to perform balanced tree reduction for AND, OR, XOR signals at upper levels
    // This reduces 10 signals down to 1 output in a balanced manner
    // Here we explicitly implement three levels: 10 -> 5 -> 3 -> 1 for AND and OR
    // XOR requires associative reduction; balanced tree implemented similarly

    // Level 2: Reduce 10 inputs to 5 outputs by pairing adjacent elements
    wire [4:0] and_lvl2;
    wire [4:0] or_lvl2;
    wire [4:0] xor_lvl2;

    generate
        for (i = 0; i < 5; i = i + 1) begin : level2_reduce
            assign and_lvl2[i] = and_lvl1[2*i] & and_lvl1[2*i+1];
            assign or_lvl2[i]  = or_lvl1[2*i] | or_lvl1[2*i+1];
            assign xor_lvl2[i] = xor_lvl1[2*i] ^ xor_lvl1[2*i+1];
        end
    endgenerate

    // Level 3: Reduce 5 inputs to 3 outputs:
    // Pair 0&1, 2&3, and leftover 4 passed through
    wire and_lvl3_0_1, and_lvl3_2_3;
    wire or_lvl3_0_1, or_lvl3_2_3;
    wire xor_lvl3_0_1, xor_lvl3_2_3;

    assign and_lvl3_0_1 = and_lvl2[0] & and_lvl2[1];
    assign or_lvl3_0_1  = or_lvl2[0]  | or_lvl2[1];
    assign xor_lvl3_0_1 = xor_lvl2[0] ^ xor_lvl2[1];

    assign and_lvl3_2_3 = and_lvl2[2] & and_lvl2[3];
    assign or_lvl3_2_3  = or_lvl2[2]  | or_lvl2[3];
    assign xor_lvl3_2_3 = xor_lvl2[2] ^ xor_lvl2[3];

    wire and_lvl3_4 = and_lvl2[4];
    wire or_lvl3_4  = or_lvl2[4];
    wire xor_lvl3_4 = xor_lvl2[4];

    // Level 4: Reduce 3 inputs to 1 output
    // AND: (and_lvl3_0_1 & and_lvl3_2_3) & and_lvl3_4
    // OR:  (or_lvl3_0_1  | or_lvl3_2_3)  | or_lvl3_4
    // XOR: (xor_lvl3_0_1 ^ xor_lvl3_2_3) ^ xor_lvl3_4

    assign out_and = (and_lvl3_0_1 & and_lvl3_2_3) & and_lvl3_4;
    assign out_or  = (or_lvl3_0_1  | or_lvl3_2_3)  | or_lvl3_4;
    assign out_xor = (xor_lvl3_0_1 ^ xor_lvl3_2_3) ^ xor_lvl3_4;

endmodule