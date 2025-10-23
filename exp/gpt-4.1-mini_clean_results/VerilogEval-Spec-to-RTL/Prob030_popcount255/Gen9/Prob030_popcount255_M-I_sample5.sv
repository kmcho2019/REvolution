module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits to count up to 17
);
    // Level 1: sum pairs of bits (8 pairs, plus leftover bit)
    wire [1:0] s0  = in[0]  + in[1];
    wire [1:0] s1  = in[2]  + in[3];
    wire [1:0] s2  = in[4]  + in[5];
    wire [1:0] s3  = in[6]  + in[7];
    wire [1:0] s4  = in[8]  + in[9];
    wire [1:0] s5  = in[10] + in[11];
    wire [1:0] s6  = in[12] + in[13];
    wire [1:0] s7  = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit sums to 3-bit sums
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit sums to 4-bit sums
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit sums to 5-bit sum
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit
    assign out = s14 + leftover;

endmodule


// 3-input carry save adder (CSA) for summing 3 inputs of N bits.
// Outputs sum and carry, both N bits. The final carry must be shifted left before addition.
module csa3 #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] c,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);
    assign {carry, sum} = a + b + c;
    // Note: this is a simple full adder expression using '+' operator in assign. 
    // Real CSA logic would be faster with XOR and AND gates but '+' is concise here.
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: Partition input into 15 groups of 17 bits
    wire [5:0] partial_counts [0:14];
    popcount17 pc0 (.in(in[16:0]),     .out(partial_counts[0]));
    popcount17 pc1 (.in(in[33:17]),    .out(partial_counts[1]));
    popcount17 pc2 (.in(in[50:34]),    .out(partial_counts[2]));
    popcount17 pc3 (.in(in[67:51]),    .out(partial_counts[3]));
    popcount17 pc4 (.in(in[84:68]),    .out(partial_counts[4]));
    popcount17 pc5 (.in(in[101:85]),   .out(partial_counts[5]));
    popcount17 pc6 (.in(in[118:102]),  .out(partial_counts[6]));
    popcount17 pc7 (.in(in[135:119]),  .out(partial_counts[7]));
    popcount17 pc8 (.in(in[152:136]),  .out(partial_counts[8]));
    popcount17 pc9 (.in(in[169:153]),  .out(partial_counts[9]));
    popcount17 pc10(.in(in[186:170]),  .out(partial_counts[10]));
    popcount17 pc11(.in(in[203:187]),  .out(partial_counts[11]));
    popcount17 pc12(.in(in[220:204]),  .out(partial_counts[12]));
    popcount17 pc13(.in(in[237:221]),  .out(partial_counts[13]));
    popcount17 pc14(.in(in[254:238]),  .out(partial_counts[14]));

    // Extend partial counts to 8 bits (max sum 17 * 15 = 255 < 8 bits)
    wire [7:0] pcount [0:14];
    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : ext_pc
            assign pcount[gi] = {2'b00, partial_counts[gi]}; // zero-extend from 6 to 8 bits
        end
    endgenerate

    // Step 2: Use carry-save addition (CSA) trees to sum 15 operands efficiently.
    // CSA stage 1: sum in groups of 3
    wire [7:0] sum1 [0:4];
    wire [7:0] carry1 [0:4];
    genvar gi1;
    generate
        for (gi1=0; gi1<5; gi1=gi1+1) begin : csa_stage1
            csa3 #(8) csa_inst (
                .a(pcount[gi1*3+0]),
                .b(pcount[gi1*3+1]),
                .c(pcount[gi1*3+2]),
                .sum(sum1[gi1]),
                .carry(carry1[gi1])
            );
        end
    endgenerate

    // Step 3: Second CSA stage: sum the 5 sums and carries from stage 1
    // We have 10 inputs (sum1[0..4], carry1[0..4]) to sum.
    // Group them into 3 groups of 3 inputs each, plus 1 leftover.
    // The leftover will be added later.

    // Stage 2 CSA groups
    wire [7:0] sum2 [0:2];
    wire [7:0] carry2 [0:2];

    csa3 #(8) csa2_0 (.a(sum1[0]),  .b(sum1[1]),  .c(sum1[2]),  .sum(sum2[0]), .carry(carry2[0]));
    csa3 #(8) csa2_1 (.a(sum1[3]),  .b(sum1[4]),  .c(carry1[0]), .sum(sum2[1]), .carry(carry2[1]));
    csa3 #(8) csa2_2 (.a(carry1[1]), .b(carry1[2]), .c(carry1[3]), .sum(sum2[2]), .carry(carry2[2]));

    // There are leftover carry1[4], and carry2[0..2] to add next

    // Combine all remaining operands to sum: carry1[4], carry2[0..2], sum2[1], sum2[2]
    // Let's gather these:

    // Remaining operands:
    // sum2[0]
    // sum2[1]
    // sum2[2]
    // carry2[0]
    // carry2[1]
    // carry2[2]
    // carry1[4]

    // We have 7 operands total now, use CSAs again.

    // Stage 3 CSA: sum in groups of 3 (2 groups) + 1 leftover
    wire [7:0] sum3 [0:1];
    wire [7:0] carry3 [0:1];

    csa3 #(8) csa3_0 (.a(sum2[0]), .b(sum2[1]), .c(sum2[2]), .sum(sum3[0]), .carry(carry3[0]));
    csa3 #(8) csa3_1 (.a(carry2[0]), .b(carry2[1]), .c(carry2[2]), .sum(sum3[1]), .carry(carry3[1]));

    // Leftover operand: carry1[4]

    // Stage 4 CSA: sum sum3[0], sum3[1], and carry1[4]
    wire [7:0] sum4;
    wire [7:0] carry4;

    csa3 #(8) csa4 (.a(sum3[0]), .b(sum3[1]), .c(carry1[4]), .sum(sum4), .carry(carry4));

    // Stage 5: Now sum all carry and sum signals left: carry3[0], carry3[1], carry4, sum4
    // This is 4 operands, use 2 CSAs + 1 final adder

    // Stage 5 CSA groups
    wire [7:0] sum5_0, carry5_0;
    csa3 #(8) csa5_0 (.a(carry3[0]), .b(carry3[1]), .c(carry4), .sum(sum5_0), .carry(carry5_0));

    // One leftover: sum4 (already used above), so leftover is none, we have sum4 included.

    // Now final sum = sum5_0 + carry5_0 shifted left by 1 bit

    wire [8:0] final_sum;

    assign final_sum = sum5_0 + (carry5_0 << 1);

    // Assign to output (only 8 bits needed)
    assign out = final_sum[7:0];

endmodule