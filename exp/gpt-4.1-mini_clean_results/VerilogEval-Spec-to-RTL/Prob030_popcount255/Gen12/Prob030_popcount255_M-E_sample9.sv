module popcount5 (
    input  [4:0] in,
    output [3:0] out  // max count 5 -> needs 3 bits, but 4 bits for safe margin
);
    // Count 1's in 5 bits by explicit addition
    wire [2:0] sum01 = in[1] + in[0];
    wire [2:0] sum23 = in[3] + in[2];
    wire [3:0] sum4 = sum01 + sum23 + in[4];
    assign out = sum4;
endmodule

module popcount2 (
    input  [1:0] in,
    output [2:0] out  // max count 2 -> 2 bits, 3 bits for margin
);
    assign out = in[0] + in[1];
endmodule

module popcount17 (
    input  [16:0] in,
    output [4:0]  out
);
    // Split 17 bits into 5+5+5+2 bits
    wire [3:0] sum0, sum1, sum2;
    wire [2:0] sum3;
    popcount5 pc0 (.in(in[4:0]),   .out(sum0));
    popcount5 pc1 (.in(in[9:5]),   .out(sum1));
    popcount5 pc2 (.in(in[14:10]), .out(sum2));
    popcount2 pc3 (.in(in[16:15]), .out(sum3));

    // Add the four partial counts: sum0 + sum1 + sum2 + sum3
    // sum0..sum2 are 4-bit, sum3 is 3-bit; extend to 5 bits for addition safety
    wire [4:0] s0 = {1'b0, sum0};
    wire [4:0] s1 = {1'b0, sum1};
    wire [4:0] s2 = {1'b0, sum2};
    wire [4:0] s3 = {2'b0, sum3};

    wire [5:0] sum01 = s0 + s1;   // up to 10
    wire [5:0] sum23 = s2 + s3;   // up to 10
    wire [6:0] sum_all = sum01 + sum23; // up to 20 (max 17), fits 7 bits but output 5 bits, safe
    assign out = sum_all[4:0]; // 5 bits are enough to hold max 17
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // Partition input into 15 blocks of 17 bits each
    wire [4:0] partial_counts [14:0]; // 5 bits per partial count

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : gen_pop17
            popcount17 pc17(.in(in[i*17 +: 17]), .out(partial_counts[i]));
        end
    endgenerate

    // Balanced adder tree to sum 15 partial 5-bit counts into 8-bit final count
    // Stage 1: sum pairs -> 7 sums + 1 leftover partial count (since 15 is odd)
    wire [6:0] sum_stage1 [6:0];
    generate
        for (i = 0; i < 7; i = i + 1) begin : sum_stage1_loop
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1]; // 5b+5b=6b, store in 7b
        end
    endgenerate
    wire [4:0] leftover0 = partial_counts[14];

    // Stage 2: sum pairs of sum_stage1 (7 elements) -> 3 sums + leftover
    wire [7:0] sum_stage2 [2:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1]; // 7b+7b=8b
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];
    assign sum_stage2[2] = sum_stage1[4] + sum_stage1[5];
    wire [6:0] leftover1 = sum_stage1[6];

    // Stage 3: sum pairs of sum_stage2 (3 elements) + leftover1 -> 2 sums + leftover
    wire [8:0] sum_stage3 [1:0];
    assign sum_stage3[0] = sum_stage2[0] + sum_stage2[1]; // 8b+8b=9b
    assign sum_stage3[1] = sum_stage2[2] + {2'b0, leftover1}; // 8b+7b zero-extended to 9b

    wire [8:0] leftover2 = {4'b0, leftover0}; // Extend leftover0 (5b) to 9b for next sum

    // Stage 4: final sum of two sums + leftover2
    wire [9:0] final_sum_1 = sum_stage3[0] + sum_stage3[1]; // 9b + 9b = 10b
    wire [9:0] final_sum   = final_sum_1 + leftover2;       // 10b + 9b <= 10b

    // Output 8 bits (max 255) - final_sum max is 255 (8 bits)
    assign out = final_sum[7:0];

endmodule