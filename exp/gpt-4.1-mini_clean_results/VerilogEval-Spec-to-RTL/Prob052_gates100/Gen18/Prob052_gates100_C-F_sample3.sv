module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Level 1: 20 groups of 5 bits each reduced with built-in reduction operators
    wire [19:0] and_lvl1;
    wire [19:0] or_lvl1;
    wire [19:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin : level1_reduce
            assign and_lvl1[i] = &in[i*5 +: 5];
            assign or_lvl1[i]  = |in[i*5 +: 5];
            assign xor_lvl1[i] = ^in[i*5 +: 5];
        end
    endgenerate

    // Level 2: Reduce pairs from level1 to get 10 signals
    wire [9:0] and_lvl2;
    wire [9:0] or_lvl2;
    wire [9:0] xor_lvl2;

    generate
        for (i = 0; i < 10; i = i + 1) begin : level2_reduce
            assign and_lvl2[i] = and_lvl1[2*i] & and_lvl1[2*i + 1];
            assign or_lvl2[i]  = or_lvl1[2*i] | or_lvl1[2*i + 1];
            assign xor_lvl2[i] = xor_lvl1[2*i] ^ xor_lvl1[2*i + 1];
        end
    endgenerate

    // Level 3: Reduce pairs from level2 to get 5 signals
    wire [4:0] and_lvl3;
    wire [4:0] or_lvl3;
    wire [4:0] xor_lvl3;

    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_reduce
            assign and_lvl3[i] = and_lvl2[2*i] & and_lvl2[2*i + 1];
            assign or_lvl3[i]  = or_lvl2[2*i] | or_lvl2[2*i + 1];
            assign xor_lvl3[i] = xor_lvl2[2*i] ^ xor_lvl2[2*i + 1];
        end
    endgenerate

    // Level 4: Reduce first 4 of level3 in two pairs and leave last element
    wire and_lvl4_0 = and_lvl3[0] & and_lvl3[1];
    wire and_lvl4_1 = and_lvl3[2] & and_lvl3[3];

    wire or_lvl4_0  = or_lvl3[0] | or_lvl3[1];
    wire or_lvl4_1  = or_lvl3[2] | or_lvl3[3];

    wire xor_lvl4_0 = xor_lvl3[0] ^ xor_lvl3[1];
    wire xor_lvl4_1 = xor_lvl3[2] ^ xor_lvl3[3];

    // Final outputs: combine level4 outputs with the leftover 5th element at level3
    assign out_and = and_lvl4_0 & and_lvl4_1 & and_lvl3[4];
    assign out_or  = or_lvl4_0 | or_lvl4_1 | or_lvl3[4];
    assign out_xor = xor_lvl4_0 ^ xor_lvl4_1 ^ xor_lvl3[4];

endmodule