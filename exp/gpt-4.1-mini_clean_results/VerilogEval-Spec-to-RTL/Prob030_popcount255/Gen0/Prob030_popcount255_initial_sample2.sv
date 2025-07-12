module TopModule(
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: count ones in groups of 8 bits
    // 255 bits / 8 = 31 groups of 8 bits and 1 group of 7 bits
    wire [3:0] count_8[30:0]; // counts of 8-bit groups, max 8 = 4 bits needed
    wire [3:0] count_7;       // count for last 7 bits

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : count8groups
            assign count_8[i] = in[i*8 +: 8][0] +
                                in[i*8 +: 8][1] +
                                in[i*8 +: 8][2] +
                                in[i*8 +: 8][3] +
                                in[i*8 +: 8][4] +
                                in[i*8 +: 8][5] +
                                in[i*8 +: 8][6] +
                                in[i*8 +: 8][7];
        end
    endgenerate

    // count the last 7 bits (bits 248 to 254)
    assign count_7 = in[248] +
                     in[249] +
                     in[250] +
                     in[251] +
                     in[252] +
                     in[253] +
                     in[254];

    // Stage 2: sum all 31 counts of 8 bits + count_7 (4-bit values)
    // sum_31_4bit = 31 * 8 max = 248, fits in 8 bits
    // We'll sum them in pairs to avoid big additions at once.

    // Sum pairs of counts:
    wire [5:0] sum_level1 [15:0]; // Each sum of two 4-bit values max 8+8=16 fits in 5 bits, use 6 bits to be safe

    generate
        for (i = 0; i < 15; i = i + 2) begin : sum_pairs
            assign sum_level1[i/2] = count_8[i] + count_8[i+1];
        end
    endgenerate
    // The last sum_level1 element is just count_8[30]
    assign sum_level1[15] = count_8[30];

    // sum_level1 has 16 elements, sum them similarly
    wire [6:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 16; i = i + 2) begin : sum_level2_gen
            assign sum_level2[i/2] = sum_level1[i] + sum_level1[i+1];
        end
    endgenerate

    // sum_level2 has 8 elements
    wire [7:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 8; i = i + 2) begin : sum_level3_gen
            assign sum_level3[i/2] = sum_level2[i] + sum_level2[i+1];
        end
    endgenerate

    // sum_level3 has 4 elements
    wire [8:0] sum_level4 [1:0];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // sum_level4 has 2 elements, add final with count_7
    wire [8:0] temp_sum;
    assign temp_sum = sum_level4[0] + sum_level4[1];
    wire [8:0] total_sum = temp_sum + count_7;

    // total_sum max 255, output 8 bits
    assign out = total_sum[7:0];

endmodule