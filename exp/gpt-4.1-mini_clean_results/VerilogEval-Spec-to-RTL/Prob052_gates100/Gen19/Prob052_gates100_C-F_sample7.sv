module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Level 1: 10 groups of 10 bits each, reduced with built-in reduction operators
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

    // Level 2: Reduce pairs from level1 (5 signals)
    wire [4:0] and_lvl2;
    wire [4:0] or_lvl2;
    wire [4:0] xor_lvl2;

    generate
        for (i = 0; i < 5; i = i + 1) begin : level2_reduce
            assign and_lvl2[i] = and_lvl1[2*i] & and_lvl1[2*i + 1];
            assign or_lvl2[i]  = or_lvl1[2*i] | or_lvl1[2*i + 1];
            assign xor_lvl2[i] = xor_lvl1[2*i] ^ xor_lvl1[2*i + 1];
        end
    endgenerate

    // Level 3: Reduce pairs from level2 (2 pairs + leftover)
    wire and_lvl3_0 = and_lvl2[0] & and_lvl2[1];
    wire and_lvl3_1 = and_lvl2[2] & and_lvl2[3];

    wire or_lvl3_0  = or_lvl2[0] | or_lvl2[1];
    wire or_lvl3_1  = or_lvl2[2] | or_lvl2[3];

    wire xor_lvl3_0 = xor_lvl2[0] ^ xor_lvl2[1];
    wire xor_lvl3_1 = xor_lvl2[2] ^ xor_lvl2[3];

    // Final outputs: combine level3 results with leftover level2[4]
    assign out_and = and_lvl3_0 & and_lvl3_1 & and_lvl2[4];
    assign out_or  = or_lvl3_0 | or_lvl3_1 | or_lvl2[4];
    assign out_xor = xor_lvl3_0 ^ xor_lvl3_1 ^ xor_lvl2[4];

endmodule