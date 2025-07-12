module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits, no loops or functions
    wire [3:0] sum0, sum1;

    // Sum lower 4 bits
    wire [2:0] sum_lo;
    assign sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits

    // Sum upper 4 bits
    wire [2:0] sum_hi;
    assign sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits

    // sum_lo and sum_hi are 3-bit each (max 4), sum can be max 8 -> 4 bits needed
    assign out = sum_lo + sum_hi; // 3-bit + 3-bit = 4-bit sum
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split the 255-bit input into 16 groups of 16 bits, last group 15 bits padded with 0
    // Each 16-bit group is popcounted by summing two popcount8 modules
    // popcount8 output is 4-bit, summing two gives max 16 ones, fits in 5 bits
    wire [3:0] pc8_l [15:0]; // lower 8 bits popcount outputs
    wire [3:0] pc8_h [15:0]; // higher 8 bits popcount outputs
    wire [4:0] pc16  [15:0]; // 16-bit groups popcount outputs

    // Group indices and bit ranges:
    // group 0: in[15:0]
    // group 1: in[31:16]
    // ...
    // group 14: in[239:224]
    // group 15: in[254:240] padded with one zero bit to make 16 bits

    // Instantiate popcount8 modules for each group, explicitly no loops/generate

    // Group 0
    popcount8 pc8_0_l (.in(in[7:0]),     .out(pc8_l[0]));
    popcount8 pc8_0_h (.in(in[15:8]),    .out(pc8_h[0]));
    assign pc16[0] = pc8_l[0] + pc8_h[0];

    // Group 1
    popcount8 pc8_1_l (.in(in[23:16]),   .out(pc8_l[1]));
    popcount8 pc8_1_h (.in(in[31:24]),   .out(pc8_h[1]));
    assign pc16[1] = pc8_l[1] + pc8_h[1];

    // Group 2
    popcount8 pc8_2_l (.in(in[39:32]),   .out(pc8_l[2]));
    popcount8 pc8_2_h (.in(in[47:40]),   .out(pc8_h[2]));
    assign pc16[2] = pc8_l[2] + pc8_h[2];

    // Group 3
    popcount8 pc8_3_l (.in(in[55:48]),   .out(pc8_l[3]));
    popcount8 pc8_3_h (.in(in[63:56]),   .out(pc8_h[3]));
    assign pc16[3] = pc8_l[3] + pc8_h[3];

    // Group 4
    popcount8 pc8_4_l (.in(in[71:64]),   .out(pc8_l[4]));
    popcount8 pc8_4_h (.in(in[79:72]),   .out(pc8_h[4]));
    assign pc16[4] = pc8_l[4] + pc8_h[4];

    // Group 5
    popcount8 pc8_5_l (.in(in[87:80]),   .out(pc8_l[5]));
    popcount8 pc8_5_h (.in(in[95:88]),   .out(pc8_h[5]));
    assign pc16[5] = pc8_l[5] + pc8_h[5];

    // Group 6
    popcount8 pc8_6_l (.in(in[103:96]),  .out(pc8_l[6]));
    popcount8 pc8_6_h (.in(in[111:104]), .out(pc8_h[6]));
    assign pc16[6] = pc8_l[6] + pc8_h[6];

    // Group 7
    popcount8 pc8_7_l (.in(in[119:112]), .out(pc8_l[7]));
    popcount8 pc8_7_h (.in(in[127:120]), .out(pc8_h[7]));
    assign pc16[7] = pc8_l[7] + pc8_h[7];

    // Group 8
    popcount8 pc8_8_l (.in(in[135:128]), .out(pc8_l[8]));
    popcount8 pc8_8_h (.in(in[143:136]), .out(pc8_h[8]));
    assign pc16[8] = pc8_l[8] + pc8_h[8];

    // Group 9
    popcount8 pc8_9_l (.in(in[151:144]), .out(pc8_l[9]));
    popcount8 pc8_9_h (.in(in[159:152]), .out(pc8_h[9]));
    assign pc16[9] = pc8_l[9] + pc8_h[9];

    // Group 10
    popcount8 pc8_10_l (.in(in[167:160]), .out(pc8_l[10]));
    popcount8 pc8_10_h (.in(in[175:168]), .out(pc8_h[10]));
    assign pc16[10] = pc8_l[10] + pc8_h[10];

    // Group 11
    popcount8 pc8_11_l (.in(in[183:176]), .out(pc8_l[11]));
    popcount8 pc8_11_h (.in(in[191:184]), .out(pc8_h[11]));
    assign pc16[11] = pc8_l[11] + pc8_h[11];

    // Group 12
    popcount8 pc8_12_l (.in(in[199:192]), .out(pc8_l[12]));
    popcount8 pc8_12_h (.in(in[207:200]), .out(pc8_h[12]));
    assign pc16[12] = pc8_l[12] + pc8_h[12];

    // Group 13
    popcount8 pc8_13_l (.in(in[215:208]), .out(pc8_l[13]));
    popcount8 pc8_13_h (.in(in[223:216]), .out(pc8_h[13]));
    assign pc16[13] = pc8_l[13] + pc8_h[13];

    // Group 14
    popcount8 pc8_14_l (.in(in[231:224]), .out(pc8_l[14]));
    popcount8 pc8_14_h (.in(in[239:232]), .out(pc8_h[14]));
    assign pc16[14] = pc8_l[14] + pc8_h[14];

    // Group 15 - last 15 bits plus one zero bit padded MSB
    wire [15:0] last_group;
    assign last_group = {1'b0, in[254:240]}; // pad MSB with 0
    popcount8 pc8_15_l (.in(last_group[7:0]),  .out(pc8_l[15]));
    popcount8 pc8_15_h (.in(last_group[15:8]), .out(pc8_h[15]));
    assign pc16[15] = pc8_l[15] + pc8_h[15];

    // Now sum the 16 pc16 values (each 5-bit) using a balanced binary tree

    // Level 1: 8 sums of 5-bit + 5-bit -> 6-bit sums
    wire [5:0] sum_l1 [7:0];
    assign sum_l1[0] = pc16[0] + pc16[1];
    assign sum_l1[1] = pc16[2] + pc16[3];
    assign sum_l1[2] = pc16[4] + pc16[5];
    assign sum_l1[3] = pc16[6] + pc16[7];
    assign sum_l1[4] = pc16[8] + pc16[9];
    assign sum_l1[5] = pc16[10] + pc16[11];
    assign sum_l1[6] = pc16[12] + pc16[13];
    assign sum_l1[7] = pc16[14] + pc16[15];

    // Level 2: 4 sums of 6-bit + 6-bit -> 7-bit sums
    wire [6:0] sum_l2 [3:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];

    // Level 3: 2 sums of 7-bit + 7-bit -> 8-bit sums
    wire [7:0] sum_l3 [1:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];

    // Level 4: final sum of two 8-bit sums -> 8-bit output
    assign out = sum_l3[0] + sum_l3[1];
endmodule