module TopModule(
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: Break input into 51 groups of 5 bits (last group padded with zeros)
    // Since 51*5=255 exactly, no padding needed
    wire [2:0] group_count [50:0]; // 3 bits to count up to 5 ones per group

    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : group5_count
            wire [4:0] bits = in[i*5 +: 5];
            // Count bits using a 5-input popcount implemented as a simple addition
            // sum bits (max 5 -> 3 bits needed)
            assign group_count[i] = bits[0] + bits[1] + bits[2] + bits[3] + bits[4];
        end
    endgenerate

    // Now sum these 51 counts step by step until one final 8-bit count remains

    // Stage 1: sum pairs of group_count -> 25 sums + 1 leftover (last element)
    // Each sum is 4 bits (max 5+5=10)
    wire [3:0] sum_stage1 [24:0];
    wire [2:0] leftover_stage1 = group_count[50];

    generate
        for (i = 0; i < 25; i = i + 1) begin : stage1_sum
            assign sum_stage1[i] = group_count[2*i] + group_count[2*i + 1];
        end
    endgenerate

    // Stage 2: sum pairs of sum_stage1 -> 12 sums + 1 leftover (leftover_stage1 promoted)
    // Max sum at stage1 = 10, sum of two = max 20 -> 5 bits
    wire [4:0] sum_stage2 [11:0];
    wire [3:0] leftover_stage2 = {1'b0, leftover_stage1}; // promote to 4 bits

    generate
        for (i = 0; i < 12; i = i + 1) begin : stage2_sum
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i + 1];
        end
    endgenerate

    // Add leftover_stage2 as the last element in stage2 sums by concatenation in next stage

    // Stage 3: sum pairs of sum_stage2 plus leftover_stage2 treated as last element
    // 12 sums -> 6 sums, plus leftover_stage2 is an extra element -> 7 elements total
    // Max sum at stage2 = 20, sum of two = max 40 -> 6 bits
    wire [5:0] sum_stage3 [5:0];
    wire [4:0] leftover_stage3 = leftover_stage2; // promote leftover_stage2 (4 bits) to 5 bits for next stage

    generate
        for (i = 0; i < 6; i = i + 1) begin : stage3_sum
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i + 1];
        end
    endgenerate

    // Stage 3 leftover: leftover_stage3 + sum_stage2[12th element if any?]  
    // Actually, sum_stage2 has 12 elements indexed 0..11, summed in pairs 0&1..10&11 -> 6 sums, leftover_stage2 is extra element, total 7 elements

    // So we have 6 sums in sum_stage3 + leftover_stage2 (now promoted to leftover_stage3)

    // Stage 4: sum pairs of sum_stage3 + leftover_stage3
    // sum_stage3: 6 elements
    // plus leftover_stage3 as 7th element
    // So pairs: (0&1), (2&3), (4&5), leftover alone
    // Max sum at stage3 = 40, sum of two = 80 -> 7 bits

    wire [6:0] sum_stage4 [3:0];
    wire [5:0] leftover_stage4 = leftover_stage3; // promote leftover_stage3 (5 bits) to 6 bits

    assign sum_stage4[0] = sum_stage3[0] + sum_stage3[1];
    assign sum_stage4[1] = sum_stage3[2] + sum_stage3[3];
    assign sum_stage4[2] = sum_stage3[4] + sum_stage3[5];
    assign sum_stage4[3] = {1'b0, leftover_stage4}; // zero extend leftover to 7 bits

    // Stage 5: sum pairs of sum_stage4
    // 4 elements, max sum approx 80, sum two -> 160 (8 bits needed)
    wire [7:0] sum_stage5 [1:0];
    assign sum_stage5[0] = sum_stage4[0] + sum_stage4[1];
    assign sum_stage5[1] = sum_stage4[2] + sum_stage4[3];

    // Stage 6: final sum of two 8-bit sums -> max 255 (8 bits)
    assign out = sum_stage5[0] + sum_stage5[1];

endmodule