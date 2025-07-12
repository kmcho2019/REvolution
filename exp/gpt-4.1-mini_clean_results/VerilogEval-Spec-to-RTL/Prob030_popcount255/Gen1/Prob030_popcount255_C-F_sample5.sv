module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Parameters for grouping
    localparam GROUP_SIZE = 16;
    localparam NUM_GROUPS = 16;

    // Partial counts per group: 5 bits each (max 16)
    wire [4:0] partial_counts [0:NUM_GROUPS-1];

    // Generate partial counts by summing each 16-bit group (except last group which has 15 bits)
    genvar gi;
    generate
        for (gi = 0; gi < NUM_GROUPS-1; gi = gi + 1) begin : gen_partial_counts_16bits
            assign partial_counts[gi] = in[gi*GROUP_SIZE +: GROUP_SIZE][0] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][1] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][2] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][3] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][4] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][5] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][6] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][7] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][8] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][9] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][10] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][11] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][12] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][13] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][14] +
                                       in[gi*GROUP_SIZE +: GROUP_SIZE][15];
        end
        // Last group with 15 bits (255 - 15*16 = 15 bits)
        // Summation of these 15 bits
        assign partial_counts[NUM_GROUPS-1] = in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][0] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][1] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][2] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][3] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][4] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][5] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][6] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][7] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][8] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][9] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][10] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][11] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][12] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][13] +
                                             in[NUM_GROUPS*GROUP_SIZE - 1 -: 15][14];
    endgenerate

    // Next stage: sum partial counts using a balanced adder tree
    // Stage 1: sum pairs of partial_counts (8 sums)
    wire [5:0] sum_stage1 [0:7]; // max 16+16=32 fits in 6 bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs of sum_stage1 (4 sums)
    wire [6:0] sum_stage2 [0:3]; // max 32+32=64 fits in 7 bits
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs of sum_stage2 (2 sums)
    wire [7:0] sum_stage3 [0:1]; // max 64+64=128 fits in 8 bits
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Final stage: sum the two results from stage 3 (max 128+128=256 fits in 9 bits but output only 8 bits needed)
    wire [8:0] sum_final;
    assign sum_final = sum_stage3[0] + sum_stage3[1];

    // Assign lower 8 bits to output (max count 255 fits in 8 bits)
    assign out = sum_final[7:0];

endmodule