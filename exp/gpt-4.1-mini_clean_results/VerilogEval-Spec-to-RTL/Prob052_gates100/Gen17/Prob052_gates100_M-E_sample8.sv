module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // --- Intermediate signals for hierarchical reduction ---
    // Level 1: 50 pairs (each pair reduces two inputs)
    wire [49:0] and_lv1, or_lv1, xor_lv1;
    genvar i;
    generate
        for (i = 0; i < 50; i = i + 1) begin : level1
            assign and_lv1[i] = in[2*i]     & in[2*i + 1];
            assign or_lv1[i]  = in[2*i]     | in[2*i + 1];
            assign xor_lv1[i] = in[2*i]     ^ in[2*i + 1];
        end
    endgenerate

    // Level 2: 25 pairs (process 50 level1 outputs)
    wire [24:0] and_lv2, or_lv2, xor_lv2;
    generate
        for (i = 0; i < 24; i = i + 1) begin : level2_pairs
            assign and_lv2[i] = and_lv1[2*i]     & and_lv1[2*i + 1];
            assign or_lv2[i]  = or_lv1[2*i]      | or_lv1[2*i + 1];
            assign xor_lv2[i] = xor_lv1[2*i]     ^ xor_lv1[2*i + 1];
        end
        // The 25th element combines the last level1 element alone (odd number)
        assign and_lv2[24] = and_lv1[48] & and_lv1[49];
        assign or_lv2[24]  = or_lv1[48]  | or_lv1[49];
        assign xor_lv2[24] = xor_lv1[48] ^ xor_lv1[49];
    endgenerate

    // Level 3: 12 pairs + 1 leftover (25 elements)
    wire [11:0] and_lv3, or_lv3, xor_lv3;
    wire        and_lv3_last, or_lv3_last, xor_lv3_last;
    generate
        for (i = 0; i < 12; i = i + 1) begin : level3_pairs
            assign and_lv3[i] = and_lv2[2*i]     & and_lv2[2*i + 1];
            assign or_lv3[i]  = or_lv2[2*i]      | or_lv2[2*i + 1];
            assign xor_lv3[i] = xor_lv2[2*i]     ^ xor_lv2[2*i + 1];
        end
    endgenerate
    assign and_lv3_last = and_lv2[24];
    assign or_lv3_last  = or_lv2[24];
    assign xor_lv3_last = xor_lv2[24];

    // Level 4: 6 pairs + 1 leftover (13 elements)
    wire [5:0] and_lv4, or_lv4, xor_lv4;
    wire       and_lv4_last, or_lv4_last, xor_lv4_last;
    generate
        for (i = 0; i < 6; i = i + 1) begin : level4_pairs
            assign and_lv4[i] = and_lv3[2*i]     & and_lv3[2*i + 1];
            assign or_lv4[i]  = or_lv3[2*i]      | or_lv3[2*i + 1];
            assign xor_lv4[i] = xor_lv3[2*i]     ^ xor_lv3[2*i + 1];
        end
    endgenerate
    assign and_lv4_last = and_lv3_last;
    assign or_lv4_last  = or_lv3_last;
    assign xor_lv4_last = xor_lv3_last;

    // Level 5: 3 pairs + 1 leftover (7 elements)
    wire [2:0] and_lv5, or_lv5, xor_lv5;
    wire       and_lv5_last, or_lv5_last, xor_lv5_last;
    generate
        for (i = 0; i < 2; i = i + 1) begin : level5_pairs
            assign and_lv5[i] = and_lv4[2*i]     & and_lv4[2*i + 1];
            assign or_lv5[i]  = or_lv4[2*i]      | or_lv4[2*i + 1];
            assign xor_lv5[i] = xor_lv4[2*i]     ^ xor_lv4[2*i + 1];
        end
    endgenerate
    assign and_lv5[2] = and_lv4[4];
    assign or_lv5[2]  = or_lv4[4];
    assign xor_lv5[2] = xor_lv4[4];

    assign and_lv5_last = and_lv4_last;
    assign or_lv5_last  = or_lv4_last;
    assign xor_lv5_last = xor_lv4_last;

    // Level 6: Combine remaining elements
    wire and_lv6_0, and_lv6_1, and_lv6_2, and_lv6_3;
    wire or_lv6_0, or_lv6_1, or_lv6_2, or_lv6_3;
    wire xor_lv6_0, xor_lv6_1, xor_lv6_2, xor_lv6_3;

    assign and_lv6_0 = and_lv5[0] & and_lv5[1];
    assign or_lv6_0  = or_lv5[0]  | or_lv5[1];
    assign xor_lv6_0 = xor_lv5[0] ^ xor_lv5[1];

    assign and_lv6_1 = and_lv5[2];
    assign or_lv6_1  = or_lv5[2];
    assign xor_lv6_1 = xor_lv5[2];

    assign and_lv6_2 = and_lv5_last;
    assign or_lv6_2  = or_lv5_last;
    assign xor_lv6_2 = xor_lv5_last;

    // Two more stages to finalize the reduction

    // Level 7
    wire and_lv7_0, and_lv7_1;
    wire or_lv7_0, or_lv7_1;
    wire xor_lv7_0, xor_lv7_1;

    assign and_lv7_0 = and_lv6_0 & and_lv6_1;
    assign or_lv7_0  = or_lv6_0  | or_lv6_1;
    assign xor_lv7_0 = xor_lv6_0 ^ xor_lv6_1;

    assign and_lv7_1 = and_lv6_2;
    assign or_lv7_1  = or_lv6_2;
    assign xor_lv7_1 = xor_lv6_2;

    // Level 8 (final outputs)
    assign out_and = and_lv7_0 & and_lv7_1;
    assign out_or  = or_lv7_0  | or_lv7_1;
    assign out_xor = xor_lv7_0 ^ xor_lv7_1;

endmodule