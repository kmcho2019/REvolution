module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // First-level partial reductions: 10 groups of 10 bits each
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

    // Second-level partial reductions: reduce 10 inputs to final output
    // For AND and OR: simple reduction with built-in operators
    assign out_and = &and_lvl1;
    assign out_or  = |or_lvl1;

    // For XOR, perform tree reduction with balanced XOR
    // XOR is associative, so we can chain:
    wire xor_reduce_0_3 = xor_lvl1[0] ^ xor_lvl1[1] ^ xor_lvl1[2] ^ xor_lvl1[3];
    wire xor_reduce_4_7 = xor_lvl1[4] ^ xor_lvl1[5] ^ xor_lvl1[6] ^ xor_lvl1[7];
    wire xor_reduce_8_9 = xor_lvl1[8] ^ xor_lvl1[9];

    assign out_xor = xor_reduce_0_3 ^ xor_reduce_4_7 ^ xor_reduce_8_9;

endmodule