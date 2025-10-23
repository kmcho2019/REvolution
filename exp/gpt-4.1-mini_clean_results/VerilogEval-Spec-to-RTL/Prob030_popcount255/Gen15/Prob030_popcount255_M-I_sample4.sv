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

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max count 7 fits in 3 bits, but use 4 bits for consistency
);
    // Balanced explicit adder tree for 7 bits:
    // sum pairs first, then sum remaining bits
    wire [1:0] sum_l1 [2:0];
    assign sum_l1[0] = in[1] + in[0];
    assign sum_l1[1] = in[3] + in[2];
    assign sum_l1[2] = in[5] + in[4];
    wire [1:0] sum_l1_extra = in[6] + 1'b0;

    wire [2:0] sum_l2 = sum_l1[0] + sum_l1[1] + sum_l1[2];
    assign out = sum_l2 + sum_l1_extra;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 32 groups of 8 bits and 1 group of 7 bits
    // 32*8=256 bits, we only have 255 bits, so last group has 7 bits.
    // So groups: [0..30] = 8 bits, group 31 = 7 bits
    // Adjust indexing accordingly: bits 0 to 255 (total 255 bits)
    // We'll process bits [0:254], last 7 bits are [248:254]
    // Actually 31*8=248 bits + 7 bits = 255 bits

    localparam NUM_FULL_BLOCKS = 31;
    localparam FULL_BLOCK_WIDTH = 8;
    localparam LAST_BLOCK_WIDTH = 7;

    wire [3:0] partial_counts [NUM_FULL_BLOCKS:0]; // 32 partial sums (31 of 8 bits, 1 of 7 bits)
    
    genvar i;
    generate
        // 31 full 8-bit blocks
        for (i = 0; i < NUM_FULL_BLOCKS; i = i + 1) begin : gen_popcount8_blocks
            popcount8 pc8 (
                .in(in[i*FULL_BLOCK_WIDTH +: FULL_BLOCK_WIDTH]),
                .out(partial_counts[i])
            );
        end
        // Last 7-bit block
        popcount7 pc7 (
            .in(in[NUM_FULL_BLOCKS*FULL_BLOCK_WIDTH +: LAST_BLOCK_WIDTH]),
            .out(partial_counts[NUM_FULL_BLOCKS])
        );
    endgenerate

    // Balanced adder tree to sum 32 partial_counts of 4 bits each (max count per block ≤ 8)
    // Max total count = 255, fits in 8 bits.

    // Level 1: sum pairs of partial counts, 16 sums, each sum max 16, need 5 bits
    wire [4:0] sum_level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of level1, 8 sums, max 32, need 6 bits
    wire [5:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of level2, 4 sums, max 64, need 7 bits
    wire [6:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs of level3, 2 sums, max 128, need 8 bits
    wire [7:0] sum_level4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Final level: sum two last sums, max 255, fits in 8 bits
    wire [7:0] sum_final = sum_level4[0] + sum_level4[1];

    assign out = sum_final;
endmodule