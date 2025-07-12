module popcount4 (
    input  [3:0] in,
    output [2:0] out // max count 4 -> 3 bits enough
);
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [2:0] total = sum01 + sum23;
    assign out = total;
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, 5 bits needed, 6 bits for safety
);
    wire [2:0] pc0, pc1, pc2, pc3;
    popcount4 pc_0 (.in(in[3:0]),    .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),    .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),   .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),  .out(pc3));
    wire [4:0] sum01 = pc0 + pc1;
    wire [4:0] sum23 = pc2 + pc3;
    wire [5:0] sum0123 = sum01 + sum23;
    assign out = sum0123 + in[16];
endmodule

// 3:2 Carry Save Adder for N-bit inputs
module csa3_2 #(parameter WIDTH=6) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] c,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);
    // sum = a ^ b ^ c
    // carry = (a&b) | (b&c) | (a&c)
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (a & c);
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 15 popcount17 blocks (each output 6 bits)
    wire [5:0] pc [14:0];
    popcount17 pc0  (.in(in[16:0]),    .out(pc[ 0]));
    popcount17 pc1  (.in(in[33:17]),   .out(pc[ 1]));
    popcount17 pc2  (.in(in[50:34]),   .out(pc[ 2]));
    popcount17 pc3  (.in(in[67:51]),   .out(pc[ 3]));
    popcount17 pc4  (.in(in[84:68]),   .out(pc[ 4]));
    popcount17 pc5  (.in(in[101:85]),  .out(pc[ 5]));
    popcount17 pc6  (.in(in[118:102]), .out(pc[ 6]));
    popcount17 pc7  (.in(in[135:119]), .out(pc[ 7]));
    popcount17 pc8  (.in(in[152:136]), .out(pc[ 8]));
    popcount17 pc9  (.in(in[169:153]), .out(pc[ 9]));
    popcount17 pc10 (.in(in[186:170]), .out(pc[10]));
    popcount17 pc11 (.in(in[203:187]), .out(pc[11]));
    popcount17 pc12 (.in(in[220:204]), .out(pc[12]));
    popcount17 pc13 (.in(in[237:221]), .out(pc[13]));
    popcount17 pc14 (.in(in[254:238]), .out(pc[14]));

    // First CSA stage: group 15 partial counts into groups of 3
    // 15 inputs -> 5 sums + 5 carries outputs (each 6 bits)
    wire [5:0] sum_stage1 [4:0];
    wire [5:0] carry_stage1 [4:0];

    csa3_2 #(6) csa1_0 (.a(pc[0]),  .b(pc[1]),  .c(pc[2]),  .sum(sum_stage1[0]),  .carry(carry_stage1[0]));
    csa3_2 #(6) csa1_1 (.a(pc[3]),  .b(pc[4]),  .c(pc[5]),  .sum(sum_stage1[1]),  .carry(carry_stage1[1]));
    csa3_2 #(6) csa1_2 (.a(pc[6]),  .b(pc[7]),  .c(pc[8]),  .sum(sum_stage1[2]),  .carry(carry_stage1[2]));
    csa3_2 #(6) csa1_3 (.a(pc[9]),  .b(pc[10]), .c(pc[11]), .sum(sum_stage1[3]),  .carry(carry_stage1[3]));
    csa3_2 #(6) csa1_4 (.a(pc[12]), .b(pc[13]), .c(pc[14]), .sum(sum_stage1[4]),  .carry(carry_stage1[4]));

    // Second CSA stage: we now have 10 vectors (5 sums + 5 carries)
    // Group in 3s again: 10 inputs -> 3 sums + 3 carries + 1 leftover
    // Leftover 1 element handled separately.

    // Arrange inputs for second CSA:
    // Inputs: sum_stage1[0..4], carry_stage1[0..4] (10 inputs)
    // We'll do csa3_2 on (sum0, sum1, sum2), (sum3, sum4, carry0), (carry1, carry2, carry3)
    // leftover = carry4

    wire [5:0] sum_stage2 [2:0];
    wire [5:0] carry_stage2 [2:0];

    csa3_2 #(6) csa2_0 (.a(sum_stage1[0]),  .b(sum_stage1[1]),  .c(sum_stage1[2]),  .sum(sum_stage2[0]),  .carry(carry_stage2[0]));
    csa3_2 #(6) csa2_1 (.a(sum_stage1[3]),  .b(sum_stage1[4]),  .c(carry_stage1[0]), .sum(sum_stage2[1]),  .carry(carry_stage2[1]));
    csa3_2 #(6) csa2_2 (.a(carry_stage1[1]), .b(carry_stage1[2]), .c(carry_stage1[3]), .sum(sum_stage2[2]),  .carry(carry_stage2[2]));

    // Leftover carry_stage1[4]
    wire [5:0] leftover = carry_stage1[4];

    // Third CSA stage: now 7 inputs (3 sums + 3 carries + leftover)
    // Group (sum2, sum_leftover, carry2), (sum0, sum1, carry0)
    // Actually do two CSAs:

    // First CSA: sum_stage2[2], leftover, carry_stage2[2]
    wire [5:0] sum_stage3_0, carry_stage3_0;
    csa3_2 #(6) csa3_0 (.a(sum_stage2[2]), .b(leftover), .c(carry_stage2[2]), .sum(sum_stage3_0), .carry(carry_stage3_0));

    // Second CSA: sum_stage2[0], sum_stage2[1], carry_stage2[1]
    wire [5:0] sum_stage3_1, carry_stage3_1;
    csa3_2 #(6) csa3_1 (.a(sum_stage2[0]), .b(sum_stage2[1]), .c(carry_stage2[1]), .sum(sum_stage3_1), .carry(carry_stage3_1));

    // Remaining carry_stage2[0] is leftover from previous stage, include it later
    wire [5:0] leftover_stage3 = carry_stage2[0];

    // Fourth CSA stage: now 5 inputs:
    // sum_stage3_0, carry_stage3_0, sum_stage3_1, carry_stage3_1, leftover_stage3

    // Group (sum_stage3_0, carry_stage3_0, sum_stage3_1)
    wire [5:0] sum_stage4_0, carry_stage4_0;
    csa3_2 #(6) csa4_0 (.a(sum_stage3_0), .b(carry_stage3_0), .c(sum_stage3_1), .sum(sum_stage4_0), .carry(carry_stage4_0));

    // Group (carry_stage3_1, leftover_stage3, 0)
    // The last operand zero-extended
    wire [5:0] sum_stage4_1, carry_stage4_1;
    csa3_2 #(6) csa4_1 (.a(carry_stage3_1), .b(leftover_stage3), .c(6'd0), .sum(sum_stage4_1), .carry(carry_stage4_1));

    // Final addition stage: sum all remaining partial sums and carries
    // Inputs: sum_stage4_0 + carry_stage4_0 + sum_stage4_1 + carry_stage4_1
    // Add in two steps (all 6-bit inputs):

    wire [7:0] sum_final_0 = sum_stage4_0 + carry_stage4_0; // 6-bit + 6-bit = 7 bits max
    wire [7:0] sum_final_1 = sum_stage4_1 + carry_stage4_1; // 7 bits max

    wire [8:0] total_sum = sum_final_0 + sum_final_1; // sum of two 8-bit numbers fits in 9 bits max (max 255)

    // Output is 8 bits, max popcount 255 fits in 8 bits, so safely truncate MSB
    assign out = total_sum[7:0];
endmodule