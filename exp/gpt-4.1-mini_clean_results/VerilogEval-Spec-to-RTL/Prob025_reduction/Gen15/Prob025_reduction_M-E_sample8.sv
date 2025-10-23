module TopModule(
    input  [7:0] in,
    output       parity
);
    wire [3:0] level1;
    wire [1:0] level2;
    wire       level3;

    // First stage: XOR pairs of input bits
    assign level1[0] = in[0] ^ in[1];
    assign level1[1] = in[2] ^ in[3];
    assign level1[2] = in[4] ^ in[5];
    assign level1[3] = in[6] ^ in[7];

    // Second stage: XOR pairs of level1 results
    assign level2[0] = level1[0] ^ level1[1];
    assign level2[1] = level1[2] ^ level1[3];

    // Final stage: XOR the two bits to get parity
    assign level3 = level2[0] ^ level2[1];

    assign parity = level3;
endmodule