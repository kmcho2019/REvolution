module popcount16 (
    input  [15:0] in,
    output [4:0] out // 5 bits to count up to 16
);
    // Level 1: sum pairs (8 x 2-bit sums)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];

    // Level 2: sum 2-bit values into 3-bit sums (4 pairs)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum 3-bit values into 4-bit sums (2 pairs)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: final sum (5 bits)
    assign out = s12 + s13;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 15 chunks of 16 bits (240 bits total) + leftover 15 bits
    // Actually, 15*16=240, leftover is bits 254:240 (15 bits)
    // Instead of handling 15 leftover bits separately, count them with popcount16 first 15 bits, adding zero for 16th bit.

    // We'll treat bits [239:0] as 15 chunks * 16 bits each
    // For leftover bits [254:240], count bits separately with a small popcount15 module

    // 1) 15 chunks of 16 bits popcount16 each
    wire [4:0] partial_counts [0:14];
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : popcount16_chunks
            popcount16 pc16 (
                .in(in[i*16 +: 16]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // 2) Popcount leftover bits [254:240] (15 bits)
    wire [14:0] leftover_bits = in[254:240];

    // Simple popcount15 using popcount16 with zero-padded 16th bit
    wire [4:0] leftover_count;
    popcount16 pc_leftover (
        .in({leftover_bits, 1'b0}),
        .out(leftover_count)
    );

    // 3) Sum all partial counts plus leftover_count using iterative balanced adder tree

    // Flatten partial_counts into vector
    wire [5*15-1:0] partial_flat;
    generate
        for (i = 0; i < 15; i = i + 1) begin
            assign partial_flat[5*i +: 5] = partial_counts[i];
        end
    endgenerate

    // Add leftover_count to partial counts array as element 15
    // We'll build an array of 16 elements (15 chunks + 1 leftover)
    wire [4:0] sums16 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin
            assign sums16[i] = partial_counts[i];
        end
    endgenerate
    assign sums16[15] = leftover_count;

    // Sum pairs bottom-up:

    // Level 1: 8 sums of two 5-bit values each -> 6 bits each
    wire [5:0] sum_level1 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin
            if (2*i+1 < 16) begin
                assign sum_level1[i] = sums16[2*i] + sums16[2*i+1];
            end else begin
                assign sum_level1[i] = sums16[2*i];
            end
        end
    endgenerate

    // Level 2: 4 sums of two 6-bit values each -> 7 bits each
    wire [6:0] sum_level2 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: 2 sums of two 7-bit values each -> 8 bits each
    wire [7:0] sum_level3 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: final sum of two 8-bit values -> max 9 bits (but 8 bits is enough for 255 max)
    wire [8:0] final_sum_9b = sum_level3[0] + sum_level3[1];

    // Output limited to 8 bits since max sum is 255 < 2^8
    assign out = final_sum_9b[7:0];

endmodule