module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding a zero MSB
    wire [255:0] in_padded = {1'b0, in};

    // Parameters
    localparam NUM_GROUPS = 32; // 256 bits / 8 bits per group
    localparam GROUP_WIDTH = 8;

    // Partial popcounts for each 8-bit group
    wire [3:0] partial_popcount [0:NUM_GROUPS-1]; // max 8 ones -> 4 bits

    genvar i, j;

    // Compute partial popcount for each 8-bit group by summing bits
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : GEN_PARTIAL_PC
            wire [GROUP_WIDTH-1:0] group_bits = in_padded[i*GROUP_WIDTH +: GROUP_WIDTH];
            wire [3:0] sum_bits;

            // Sum bits of the group using bitwise addition tree
            // Approach: sum all bits with a simple adder tree of bits
            // Efficient way: Use a parallel reduction with + operator for small width
            
            assign sum_bits = group_bits[0] + group_bits[1] + group_bits[2] + group_bits[3]
                            + group_bits[4] + group_bits[5] + group_bits[6] + group_bits[7];
            assign partial_popcount[i] = sum_bits;
        end
    endgenerate

    // Now sum the 32 partial_popcounts (each 4 bits) down to one total sum (9 bits)
    // Use a balanced adder tree to sum the partial_popcount array
    // At each stage, sum pairs of values to get the next stage's values, until one sum remains

    // We'll need enough stages to reduce 32 down to 1:
    // Stage 0: 32 elements -> 16 sums
    // Stage 1: 16 -> 8
    // Stage 2: 8 -> 4
    // Stage 3: 4 -> 2
    // Stage 4: 2 -> 1

    // Use arrays of wires to hold intermediate sums at each stage
    // Width of each sum increases by 1 bit per stage to avoid overflow

    // Stage widths:
    // partial_popcount bits: 4 bits (max 8)
    // sum widths per stage = 4 + stage

    // Stage 0 input width: 4
    // Stage 1 sum width: 5
    // Stage 2 sum width: 6
    // Stage 3 sum width: 7
    // Stage 4 sum width: 8
    // Stage 5 sum width: 9 (final output)

    // Define wires for each stage sums:
    // Stage 0 input: partial_popcount (32 elements, 4 bits each)
    // Stage 1: 16 elements, 5 bits each
    // Stage 2: 8 elements, 6 bits each
    // Stage 3: 4 elements, 7 bits each
    // Stage 4: 2 elements, 8 bits each
    // Stage 5: 1 element, 9 bits (final)

    // Stage 1 sums (16 elements)
    wire [4:0] stage1_sums [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : GEN_STAGE1
            assign stage1_sums[i] = partial_popcount[2*i] + partial_popcount[2*i + 1];
        end
    endgenerate

    // Stage 2 sums (8 elements)
    wire [5:0] stage2_sums [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : GEN_STAGE2
            assign stage2_sums[i] = stage1_sums[2*i] + stage1_sums[2*i + 1];
        end
    endgenerate

    // Stage 3 sums (4 elements)
    wire [6:0] stage3_sums [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_STAGE3
            assign stage3_sums[i] = stage2_sums[2*i] + stage2_sums[2*i + 1];
        end
    endgenerate

    // Stage 4 sums (2 elements)
    wire [7:0] stage4_sums [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : GEN_STAGE4
            assign stage4_sums[i] = stage3_sums[2*i] + stage3_sums[2*i + 1];
        end
    endgenerate

    // Stage 5 sum (1 element) - final popcount
    wire [8:0] final_popcount;
    assign final_popcount = stage4_sums[0] + stage4_sums[1];

    // The maximum number of ones is 255, fits in 8 bits, but we keep 9 bits here for safety
    assign out = final_popcount[7:0];

endmodule