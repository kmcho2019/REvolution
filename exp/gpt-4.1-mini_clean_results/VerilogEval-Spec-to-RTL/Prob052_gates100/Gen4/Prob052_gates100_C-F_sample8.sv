module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // First-level partial reductions: 20 groups of 5 bits
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

    // Second-level partial reductions: reduce pairs of level1 results
    // 20 inputs reduce to 10 outputs by pairing adjacent bits
    wire [9:0] and_lvl2;
    wire [9:0] or_lvl2;
    wire [9:0] xor_lvl2;

    generate
        for (i = 0; i < 10; i = i + 1) begin : level2_reduce
            assign and_lvl2[i] = and_lvl1[2*i] & and_lvl1[2*i+1];
            assign or_lvl2[i]  = or_lvl1[2*i] | or_lvl1[2*i+1];
            assign xor_lvl2[i] = xor_lvl1[2*i] ^ xor_lvl1[2*i+1];
        end
    endgenerate

    // Third-level partial reductions: reduce pairs again to 5 outputs
    wire [4:0] and_lvl3;
    wire [4:0] or_lvl3;
    wire [4:0] xor_lvl3;

    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_reduce
            assign and_lvl3[i] = and_lvl2[2*i] & and_lvl2[2*i+1];
            assign or_lvl3[i]  = or_lvl2[2*i] | or_lvl2[2*i+1];
            assign xor_lvl3[i] = xor_lvl2[2*i] ^ xor_lvl2[2*i+1];
        end
    endgenerate

    // Fourth-level partial reduction: reduce pairs to 2 outputs, with leftover handled
    wire and_lvl4_0, and_lvl4_1;
    wire or_lvl4_0, or_lvl4_1;
    wire xor_lvl4_0, xor_lvl4_1;

    // first pair of 2 from lvl3 indices 0 and 1
    assign and_lvl4_0 = and_lvl3[0] & and_lvl3[1];
    assign or_lvl4_0  = or_lvl3[0] | or_lvl3[1];
    assign xor_lvl4_0 = xor_lvl3[0] ^ xor_lvl3[1];

    // second pair of 2 from lvl3 indices 2 and 3
    assign and_lvl4_1 = and_lvl3[2] & and_lvl3[3];
    assign or_lvl4_1  = or_lvl3[2] | or_lvl3[3];
    assign xor_lvl4_1 = xor_lvl3[2] ^ xor_lvl3[3];

    // Handle leftover lvl3[4] for the final reduction

    // Final outputs:
    // AND: and_lvl4_0 & and_lvl4_1 & and_lvl3[4]
    assign out_and = and_lvl4_0 & and_lvl4_1 & and_lvl3[4];

    // OR: or_lvl4_0 | or_lvl4_1 | or_lvl3[4]
    assign out_or  = or_lvl4_0 | or_lvl4_1 | or_lvl3[4];

    // XOR: xor_lvl4_0 ^ xor_lvl4_1 ^ xor_lvl3[4]
    assign out_xor = xor_lvl4_0 ^ xor_lvl4_1 ^ xor_lvl3[4];

endmodule