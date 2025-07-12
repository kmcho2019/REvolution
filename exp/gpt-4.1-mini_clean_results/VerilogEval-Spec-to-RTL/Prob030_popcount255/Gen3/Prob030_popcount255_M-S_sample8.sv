module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Break input into 32 groups of 8 bits and one group of 7 bits (32*8+7=256+ -1 = 255)
    // Sum each 8-bit chunk to a 5-bit partial count (max 8 ones)
    // Sum the last 7-bit chunk separately (max 7 ones)
    wire [4:0] partial_sums8 [31:0];
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : sum_8bit_chunks
            assign partial_sums8[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3] +
                                     in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
        end
        // Last chunk is 7 bits: bits 248 to 254
        assign partial_sums8[31] = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];
    endgenerate

    // Sum all 32 partial sums (each max 8, except last max 7)
    // Use a balanced tree of adders
    // Level 1: 16 sums of two 5-bit partial sums (max 16) -> 6 bits
    wire [5:0] sum_level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_sums8[2*i] + partial_sums8[2*i+1];
        end
    endgenerate

    // Level 2: 8 sums of two 6-bit sums (max 32) -> 7 bits
    wire [6:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: 4 sums of two 7-bit sums (max 64) -> 8 bits
    wire [7:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: 2 sums of two 8-bit sums (max 128) -> 8 bits (overflow fits into 8 bits since max is 255)
    wire [7:0] sum_level4 [1:0];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // Level 5: final sum of two 8-bit sums
    assign out = sum_level4[0] + sum_level4[1];

endmodule