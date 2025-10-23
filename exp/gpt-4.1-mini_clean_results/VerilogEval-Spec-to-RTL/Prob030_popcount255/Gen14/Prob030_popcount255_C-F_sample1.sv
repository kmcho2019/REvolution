module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // LUT-style add tree for 8 bits
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567;      // max 8
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones => 4 bits for uniform width
);
    // LUT-style add tree for 7 bits
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum45 = in[4] + in[5];
    wire       bit6 = in[6];

    wire [2:0] sum0123 = sum02 + sum13;   // max 4
    wire [2:0] sum4546 = sum45 + bit6;    // max 3

    assign out = sum0123 + sum4546;       // max 7
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    localparam NUM_FULL_CHUNKS = 31;
    localparam NUM_CHUNKS = 32; // 31x8 bits + 1x7 bits

    // Step 1: partial counts from chunks: each 4 bits wide (0..8)
    wire [3:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : gen_pop8_chunks
            popcount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        popcount7 pc7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Step 2: Balanced summation tree by fixed stages with controlled widths:

    // Stage 1: sum pairs of 4-bit partial counts -> 16 sums of 5 bits (max 8+8=16)
    wire [4:0] stage1_sums [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            assign stage1_sums[i] = partial_counts[i*2] + partial_counts[i*2+1]; // 4+4 bits inputs
        end
    endgenerate

    // Stage 2: sum pairs of 5-bit sums -> 8 sums of 6 bits (max 16+16=32)
    wire [5:0] stage2_sums [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            assign stage2_sums[i] = stage1_sums[i*2] + stage1_sums[i*2+1]; // 5+5 bits inputs
        end
    endgenerate

    // Stage 3: sum pairs of 6-bit sums -> 4 sums of 7 bits (max 32+32=64)
    wire [6:0] stage3_sums [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3
            assign stage3_sums[i] = stage2_sums[i*2] + stage2_sums[i*2+1]; // 6+6 bits inputs
        end
    endgenerate

    // Stage 4: sum pairs of 7-bit sums -> 2 sums of 8 bits (max 64+64=128)
    wire [7:0] stage4_sums [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4
            assign stage4_sums[i] = stage3_sums[i*2] + stage3_sums[i*2+1]; // 7+7 bits inputs
        end
    endgenerate

    // Stage 5: final sum of two 8-bit sums -> 9 bits (max 128+128=256)
    wire [8:0] final_sum;
    assign final_sum = stage4_sums[0] + stage4_sums[1]; // 8+8 bits inputs

    // The maximum number of ones is 255, so final_sum fits in 8 bits; 9th bit can only be 0 or 1
    // We clip the final output to 8 bits as required.
    assign out = final_sum[7:0];

endmodule