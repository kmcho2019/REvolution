module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Level 0: group bits into 3-bit groups and count bits in each
    // 255 bits / 3 = 85 groups + 0 leftover
    wire [1:0] sum_lvl0 [0:84];

    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : lvl0
            // For groups of 3 bits, sum can be 0 to 3 -> 2 bits needed
            wire [2:0] group_bits;
            if (i == 84) begin
                // Last group: only bits 252 to 254
                assign group_bits = {1'b0, in[i*3 + 1], in[i*3]};
                // To include bit 254 if exists:
                // Actually bits: 84*3 = 252, indices 252,253,254 valid
                // So group_bits = {in[254], in[253], in[252]}
                assign group_bits = {in[254], in[253], in[252]};
            end else begin
                assign group_bits = in[i*3 +: 3];
            end

            assign sum_lvl0[i] = group_bits[0] + group_bits[1] + group_bits[2];
        end
    endgenerate

    // Level 1: sum groups of 3 from level 0 (each 2 bits wide) => max sum 3*3=9 (4 bits)
    // 85 groups at level 0
    // group into 3-level1 groups: 85 / 3 = 28 groups + 1 leftover
    wire [3:0] sum_lvl1 [0:28];

    generate
        for (i = 0; i < 28; i = i + 1) begin : lvl1
            assign sum_lvl1[i] = sum_lvl0[i*3] + sum_lvl0[i*3+1] + sum_lvl0[i*3+2];
        end
        // leftover group (index 28): sum the remaining one group (index 84)
        assign sum_lvl1[28] = sum_lvl0[84];
    endgenerate

    // Level 2: sum groups of 3 from level 1 (4 bits wide)
    // 29 groups at level 1, grouped by 3 -> 9 groups + 2 leftover
    wire [5:0] sum_lvl2 [0:10];

    generate
        for (i = 0; i < 9; i = i + 1) begin : lvl2
            assign sum_lvl2[i] = sum_lvl1[i*3] + sum_lvl1[i*3+1] + sum_lvl1[i*3+2];
        end
        // leftover groups 27, 28 at level 1
        assign sum_lvl2[9] = sum_lvl1[27] + sum_lvl1[28];
        assign sum_lvl2[10] = 6'd0;
    endgenerate

    // Level 3: sum groups of 3 from level 2 (6 bits wide)
    // 11 groups at level 2, grouped by 3 -> 3 groups + 2 leftover
    wire [7:0] sum_lvl3 [0:4];

    generate
        for (i = 0; i < 3; i = i + 1) begin : lvl3
            assign sum_lvl3[i] = sum_lvl2[i*3] + sum_lvl2[i*3+1] + sum_lvl2[i*3+2];
        end
        // leftover groups 9,10 at level 2
        assign sum_lvl3[3] = sum_lvl2[9] + sum_lvl2[10];
        assign sum_lvl3[4] = 8'd0;
    endgenerate

    // Level 4: sum all from level 3 (8 bits wide)
    wire [8:0] sum_lvl4;
    assign sum_lvl4 = sum_lvl3[0] + sum_lvl3[1] + sum_lvl3[2] + sum_lvl3[3] + sum_lvl3[4];

    // Output: the 9-bit sum fits 8 bits, max 255 fits in 8 bits but to be safe use 8 bits output.
    assign out = sum_lvl4[7:0];

endmodule