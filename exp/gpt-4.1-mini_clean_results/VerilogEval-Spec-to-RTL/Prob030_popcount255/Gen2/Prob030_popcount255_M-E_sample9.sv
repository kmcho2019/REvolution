module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Parameters for group sizing
    localparam GROUP_SIZE = 17;
    localparam NUM_GROUPS = 15;

    // Partial sums for each group
    wire [4:0] partial_counts [0:NUM_GROUPS-1]; // 5 bits to count up to 17 max ones

    genvar g, b;
    
    // Function to do population count on a small input vector (up to 17 bits) by summing bits
    // Implemented as a parameterized parallel popcount with a generate block

    generate
        for (g = 0; g < NUM_GROUPS; g = g + 1) begin : GROUPS
            wire [GROUP_SIZE-1:0] group_bits;
            if (g < NUM_GROUPS - 1) begin
                assign group_bits = in[g*GROUP_SIZE +: GROUP_SIZE];
            end else begin
                // The last group only has 255 - 14*17 = 255 - 238 = 17 bits anyway
                assign group_bits = in[g*GROUP_SIZE +: GROUP_SIZE];
            end

            // Count ones in group_bits: sum bits
            // Use a reduction adder tree for 17 bits
            
            wire [4:0] sum_level1 [0:8];
            wire [4:0] sum_level2 [0:4];
            wire [4:0] sum_level3 [0:2];
            wire [4:0] sum_level4 [0:1];

            // Level 1: Pair bits -> 8 sums of 2 bits, plus one leftover bit
            for (b = 0; b < 8; b = b + 1) begin : LEVEL1
                assign sum_level1[b] = group_bits[2*b] + group_bits[2*b+1];
            end
            assign sum_level1[8] = group_bits[16]; // leftover bit

            // Level 2: sum pairs of sum_level1 outputs
            for (b = 0; b < 4; b = b + 1) begin : LEVEL2
                assign sum_level2[b] = sum_level1[2*b] + sum_level1[2*b+1];
            end
            assign sum_level2[4] = sum_level1[8]; // leftover

            // Level 3: sum pairs of sum_level2 outputs
            for (b = 0; b < 2; b = b + 1) begin : LEVEL3
                assign sum_level3[b] = sum_level2[2*b] + sum_level2[2*b+1];
            end
            assign sum_level3[2] = sum_level2[4]; // leftover

            // Level 4: sum pairs of sum_level3 outputs
            assign sum_level4[0] = sum_level3[0] + sum_level3[1];
            assign sum_level4[1] = sum_level3[2];

            // Level 5: final sum for group
            assign partial_counts[g] = sum_level4[0] + sum_level4[1];

        end
    endgenerate

    // Now sum partial_counts (15 values of max 17) to get final population count
    // partial_counts max sum = 15 * 17 = 255 (fits in 8 bits)

    wire [7:0] sum_level1 [0:6];
    wire [7:0] sum_level2 [0:3];
    wire [7:0] sum_level3 [0:1];
    wire [7:0] final_sum;

    // Level 1: sum pairs of partial_counts
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : FINAL_L1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate
    // leftover partial count 14th index
    wire [7:0] leftover = {3'b000, partial_counts[14]}; // extend 5 bits to 8 bits

    // Level 2: sum pairs of sum_level1
    generate
        for (i = 0; i < 3; i = i + 1) begin : FINAL_L2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate
    // leftover sum_level1[6]
    wire [7:0] leftover_l1 = sum_level1[6];

    // Level 3: sum pairs of sum_level2
    assign sum_level3[0] = sum_level2[0] + sum_level2[1];
    assign sum_level3[1] = sum_level2[2] + leftover_l1;

    // Level 4: sum final two sums + leftover from first level
    assign final_sum = sum_level3[0] + sum_level3[1] + leftover;

    assign out = final_sum;

endmodule