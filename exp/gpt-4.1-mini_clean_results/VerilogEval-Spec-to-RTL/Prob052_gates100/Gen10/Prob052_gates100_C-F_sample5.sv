module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Level 1: Partial reductions on groups of 4 bits (25 groups)
    // For last group (index 24), only bits [99:96], so always 4 bits per group (100 bits / 4 = 25 groups)
    wire [24:0] and_lvl1;
    wire [24:0] or_lvl1;
    wire [24:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : level1_reduce
            assign and_lvl1[i] = &in[i*4 +: 4];
            assign or_lvl1[i]  = |in[i*4 +: 4];
            assign xor_lvl1[i] = ^in[i*4 +: 4];
        end
    endgenerate

    // Balanced binary tree reduction helper macro for variable input count
    // We implement reductions stage by stage: 25 -> 13 -> 7 -> 4 -> 2 -> 1
    // At each stage, pair adjacent signals; if odd count, propagate leftover signal forward.

    // Level 2: reduce 25 to 13
    wire [12:0] and_lvl2;
    wire [12:0] or_lvl2;
    wire [12:0] xor_lvl2;

    generate
        for (i = 0; i < 12; i = i + 1) begin : level2_reduce_pairs
            assign and_lvl2[i] = and_lvl1[2*i]   & and_lvl1[2*i +1];
            assign or_lvl2[i]  = or_lvl1[2*i]    | or_lvl1[2*i +1];
            assign xor_lvl2[i] = xor_lvl1[2*i]   ^ xor_lvl1[2*i +1];
        end
    endgenerate
    // leftover element at index 24 of lvl1 promoted directly
    assign and_lvl2[12] = and_lvl1[24];
    assign or_lvl2[12]  = or_lvl1[24];
    assign xor_lvl2[12] = xor_lvl1[24];

    // Level 3: reduce 13 to 7
    wire [6:0] and_lvl3;
    wire [6:0] or_lvl3;
    wire [6:0] xor_lvl3;

    generate
        for (i = 0; i < 6; i = i + 1) begin : level3_reduce_pairs
            assign and_lvl3[i] = and_lvl2[2*i]   & and_lvl2[2*i +1];
            assign or_lvl3[i]  = or_lvl2[2*i]    | or_lvl2[2*i +1];
            assign xor_lvl3[i] = xor_lvl2[2*i]   ^ xor_lvl2[2*i +1];
        end
    endgenerate
    // leftover element at index 12 promoted
    assign and_lvl3[6] = and_lvl2[12];
    assign or_lvl3[6]  = or_lvl2[12];
    assign xor_lvl3[6] = xor_lvl2[12];

    // Level 4: reduce 7 to 4
    wire [3:0] and_lvl4;
    wire [3:0] or_lvl4;
    wire [3:0] xor_lvl4;

    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_reduce_pairs
            assign and_lvl4[i] = and_lvl3[2*i]   & and_lvl3[2*i +1];
            assign or_lvl4[i]  = or_lvl3[2*i]    | or_lvl3[2*i +1];
            assign xor_lvl4[i] = xor_lvl3[2*i]   ^ xor_lvl3[2*i +1];
        end
    endgenerate
    // leftover element at index 6 promoted
    assign and_lvl4[3] = and_lvl3[6];
    assign or_lvl4[3]  = or_lvl3[6];
    assign xor_lvl4[3] = xor_lvl3[6];

    // Level 5: reduce 4 to 2
    wire [1:0] and_lvl5;
    wire [1:0] or_lvl5;
    wire [1:0] xor_lvl5;

    generate
        for (i = 0; i < 2; i = i + 1) begin : level5_reduce_pairs
            assign and_lvl5[i] = and_lvl4[2*i]   & and_lvl4[2*i +1];
            assign or_lvl5[i]  = or_lvl4[2*i]    | or_lvl4[2*i +1];
            assign xor_lvl5[i] = xor_lvl4[2*i]   ^ xor_lvl4[2*i +1];
        end
    endgenerate

    // Level 6: reduce 2 to 1 (final output)
    assign out_and = and_lvl5[0] & and_lvl5[1];
    assign out_or  = or_lvl5[0]  | or_lvl5[1];
    assign out_xor = xor_lvl5[0] ^ xor_lvl5[1];

endmodule