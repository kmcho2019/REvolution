module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // First-level intermediate partial reductions: 10 groups of 10 bits
    wire [9:0] and_lvl1;
    wire [9:0] or_lvl1;
    wire [9:0] xor_lvl1;

    genvar i, j;
    generate
        for (i = 0; i < 10; i = i + 1) begin : first_level
            wire [9:0] group = in[(i*10)+9 -: 10]; // 10 bits for this group

            // Compute partial reductions for each group
            assign and_lvl1[i] = &group;
            assign or_lvl1[i]  = |group;
            assign xor_lvl1[i] = ^group;
        end
    endgenerate

    // Second-level reductions: reduce 10 signals to a single output each
    // We'll implement a balanced tree manually for these 10 signals

    // Level 2: 5 pairs reduced to 5 signals
    wire [4:0] and_lvl2;
    wire [4:0] or_lvl2;
    wire [4:0] xor_lvl2;

    generate
        for (j = 0; j < 5; j = j + 1) begin : second_level
            assign and_lvl2[j] = and_lvl1[j*2] & and_lvl1[j*2+1];
            assign or_lvl2[j]  = or_lvl1[j*2]  | or_lvl1[j*2+1];
            assign xor_lvl2[j] = xor_lvl1[j*2] ^ xor_lvl1[j*2+1];
        end
    endgenerate

    // Level 3: reduce 5 signals to a single output each
    // For AND and OR, chain reductions; for XOR, chain XORs

    wire and_lvl3_0 = and_lvl2[0] & and_lvl2[1];
    wire and_lvl3_1 = and_lvl2[2] & and_lvl2[3];
    wire and_lvl3_rest = and_lvl2[4];

    wire or_lvl3_0 = or_lvl2[0] | or_lvl2[1];
    wire or_lvl3_1 = or_lvl2[2] | or_lvl2[3];
    wire or_lvl3_rest = or_lvl2[4];

    wire xor_lvl3_0 = xor_lvl2[0] ^ xor_lvl2[1];
    wire xor_lvl3_1 = xor_lvl2[2] ^ xor_lvl2[3];
    wire xor_lvl3_rest = xor_lvl2[4];

    // Level 4: combine all final signals to single output

    assign out_and = and_lvl3_0 & and_lvl3_1 & and_lvl3_rest;
    assign out_or  = or_lvl3_0  | or_lvl3_1  | or_lvl3_rest;
    assign out_xor = xor_lvl3_0 ^ xor_lvl3_1 ^ xor_lvl3_rest;

endmodule