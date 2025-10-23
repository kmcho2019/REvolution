module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // LUT-style add tree for 8 bits (Example 1)
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
    // LUT-style add tree for 7 bits (Example 1)
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

    // Number of chunks: 31 of 8 bits + 1 of 7 bits
    localparam NUM_FULL_CHUNKS = 31;
    localparam NUM_CHUNKS = 32;

    // Partial counts: 32 chunks each 4 bits wide (uniform width)
    wire [3:0] partial_counts [NUM_CHUNKS-1:0];

    genvar i;
    generate
        // Instantiate popcount8 for 31 full 8-bit chunks
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : gen_pop8_chunks
            popcount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        // Instantiate popcount7 for last 7 bits (bits 254:248)
        popcount7 pc7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Balanced adder tree for summing 32 partial counts (4-bit each)
    // Level widths increase by 1 bit per level due to maximum sums doubling

    // Level 1: 32 inputs of 4 bits -> 16 outputs of 5 bits (max sum 16)
    wire [4:0] sum_level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_l1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i + 1];
        end
    endgenerate

    // Level 2: 16 inputs of 5 bits -> 8 outputs of 6 bits (max sum 32)
    wire [5:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_l2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
    endgenerate

    // Level 3: 8 inputs of 6 bits -> 4 outputs of 7 bits (max sum 64)
    wire [6:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_l3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    // Level 4: 4 inputs of 7 bits -> 2 outputs of 8 bits (max sum 128)
    wire [7:0] sum_level4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_l4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i + 1];
        end
    endgenerate

    // Level 5: final sum of 2 inputs 8 bits -> output 8 bits (max 255)
    assign out = sum_level4[0] + sum_level4[1];

endmodule