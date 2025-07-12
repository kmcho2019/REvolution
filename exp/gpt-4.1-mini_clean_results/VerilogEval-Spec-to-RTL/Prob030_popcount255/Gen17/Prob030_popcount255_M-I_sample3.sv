module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Stage 0: count bits directly for each bit as 1-bit "popcount"
    // Stage 1: sum every 2 bits -> 128 sums (last 1 bit alone)
    wire [1:0] stage1 [127:0];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : stage1_pair
            // sum pairs: in[2*i] + in[2*i+1]
            assign stage1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    // The last bit is alone (bit 254)
    wire [0:0] stage1_last = in[254];

    // Stage 2: sum every 2 stage1 values (4 bits total) -> 64 sums
    wire [2:0] stage2 [63:0];
    generate
        for (i = 0; i < 63; i = i + 1) begin : stage2_pair
            assign stage2[i] = stage1[2*i] + stage1[2*i+1]; // max 4 bits
        end
    endgenerate
    // Include last stage1 element (stage1[127]) + stage1_last for final
    wire [2:0] stage2_last = stage1[127] + stage1_last; // max 2 bits + 1 bit = 3 bits

    // Stage 3: sum every 2 stage2 values (6 bits total) -> 32 sums
    wire [3:0] stage3 [31:0];
    generate
        for (i = 0; i < 31; i = i + 1) begin : stage3_pair
            assign stage3[i] = stage2[2*i] + stage2[2*i+1]; // max 6 bits
        end
    endgenerate
    // The last one is stage2_last (3 bits) alone
    wire [3:0] stage3_last = stage2_last;

    // Stage 4: sum every 2 stage3 values (8 bits total) -> 16 sums
    wire [4:0] stage4 [15:0];
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage4_pair
            assign stage4[i] = stage3[2*i] + stage3[2*i+1]; // max 8 bits
        end
    endgenerate
    // The last one is stage3_last alone (4 bits)
    wire [4:0] stage4_last = stage3_last;

    // Stage 5: sum every 2 stage4 values (9 bits total) -> 8 sums
    wire [5:0] stage5 [7:0];
    generate
        for (i = 0; i < 7; i = i + 1) begin : stage5_pair
            assign stage5[i] = stage4[2*i] + stage4[2*i+1]; // max 9 bits
        end
    endgenerate
    // Last is stage4_last (5 bits) alone
    wire [5:0] stage5_last = stage4_last;

    // Stage 6: sum every 2 stage5 values (11 bits total) -> 4 sums
    wire [6:0] stage6 [3:0];
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6_pair
            assign stage6[i] = stage5[2*i] + stage5[2*i+1]; // max 11 bits
        end
    endgenerate
    // Last is stage5_last (6 bits) alone
    wire [6:0] stage6_last = stage5_last;

    // Stage 7: sum every 2 stage6 values (13 bits total) -> 2 sums
    wire [7:0] stage7 [1:0];
    assign stage7[0] = stage6[0] + stage6[1]; // max 13 bits
    assign stage7[1] = stage6[2] + stage6_last; // max 13 bits

    // Stage 8: sum the last 2 values to get final output (max 8 bits)
    assign out = stage7[0] + stage7[1]; // max 8 bits needed for 255 ones
endmodule