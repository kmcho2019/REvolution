module TopModule(
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: count ones in groups of 8 bits
    // 255 bits / 8 = 31 groups of 8 bits and 1 group of 7 bits
    wire [4:0] count_8 [30:0]; // max count per group is 8, so 4 bits are enough, 5 bits used to be safe
    wire [3:0] count_7;         // count for last 7 bits, max 7 -> 3 bits sufficient, 4 bits for safety

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : count8groups
            assign count_8[i] = in[(i*8)+0] +
                                in[(i*8)+1] +
                                in[(i*8)+2] +
                                in[(i*8)+3] +
                                in[(i*8)+4] +
                                in[(i*8)+5] +
                                in[(i*8)+6] +
                                in[(i*8)+7];
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

    // Stage 2: sum all 31 counts of 8 bits + count_7 (5-bit values)
    // max sum = 31*8 + 7 = 255 fits in 8 bits

    // Sum pairs of counts:
    // sum_level1: 16 elements (15 pairs + 1 leftover)
    wire [6:0] sum_level1 [15:0]; // max sum 8+8=16, use 7 bits for margin

    generate
        for (i = 0; i < 30; i = i + 2) begin : sum_pairs
            assign sum_level1[i/2] = count_8[i] + count_8[i+1];
        end
    endgenerate
    // last leftover count_8[30]
    assign sum_level1[15] = count_8[30];

    // sum_level2: sum 16 elements in pairs to get 8 elements
    wire [7:0] sum_level2 [7:0]; // max sum 16+16=32, 8 bits enough
    generate
        for (i = 0; i < 16; i = i + 2) begin : sum_level2_gen
            assign sum_level2[i/2] = sum_level1[i] + sum_level1[i+1];
        end
    endgenerate

    // sum_level3: 8 elements summed in pairs -> 4 elements
    wire [8:0] sum_level3 [3:0]; // max sum 32+32=64, 9 bits enough
    generate
        for (i = 0; i < 8; i = i + 2) begin : sum_level3_gen
            assign sum_level3[i/2] = sum_level2[i] + sum_level2[i+1];
        end
    endgenerate

    // sum_level4: 4 elements summed in pairs -> 2 elements
    wire [9:0] sum_level4 [1:0]; // max sum 64+64=128, 10 bits enough
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // sum_level5: 2 elements summed + count_7
    wire [10:0] sum_level5;
    assign sum_level5 = sum_level4[0] + sum_level4[1] + count_7; // max 128+128+7=263, 9 bits enough, using 11 bits for safety

    // Output is lower 8 bits of the sum (max is 255)
    assign out = sum_level5[7:0];

endmodule