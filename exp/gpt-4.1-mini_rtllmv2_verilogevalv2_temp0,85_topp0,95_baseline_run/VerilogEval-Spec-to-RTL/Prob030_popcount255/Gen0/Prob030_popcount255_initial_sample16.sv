module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First, count bits in groups of 8 (except last group which has 7 bits)
    wire [3:0] count8 [31:0]; // 32 groups (31 of 8 bits, 1 of 7 bits)

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : group8
            assign count8[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3]
                             + in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
        end
        // Last group has only 7 bits: bits 248 to 254
        assign count8[31] = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];
    endgenerate

    // Now sum all 32 counts (each 4 bits)
    // We'll sum them in a tree structure to get the final 8-bit result

    // Level 1: sum pairs of count8[ ] to get 16 sums (5 bits each)
    wire [4:0] sum_level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            assign sum_level1[i] = count8[2*i] + count8[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of sum_level1 to get 8 sums (6 bits each)
    wire [5:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 to get 4 sums (7 bits each)
    wire [6:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs of sum_level3 to get 2 sums (8 bits each)
    wire [7:0] sum_level4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: sum the last two sums to get the final count (8 bits)
    assign out = sum_level4[0] + sum_level4[1];

endmodule