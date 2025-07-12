module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits, no loops or functions
    wire [2:0] sum_lo, sum_hi;

    // Sum lower 4 bits
    assign sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits

    // Sum upper 4 bits
    assign sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits

    // sum_lo and sum_hi are 3-bit each (max 4), sum can be max 8 -> 4 bits needed
    assign out = sum_lo + sum_hi; // 3-bit + 3-bit = 4-bit sum
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // 32 instances of popcount8: 31 full 8-bit chunks + 1 zero-padded last 7-bit chunk
    wire [3:0] pc8 [31:0];

    // Instantiate 31 popcount8 modules for full 8-bit chunks
    popcount8 pc8_00 (.in(in[7:0]),     .out(pc8[0]));
    popcount8 pc8_01 (.in(in[15:8]),    .out(pc8[1]));
    popcount8 pc8_02 (.in(in[23:16]),   .out(pc8[2]));
    popcount8 pc8_03 (.in(in[31:24]),   .out(pc8[3]));
    popcount8 pc8_04 (.in(in[39:32]),   .out(pc8[4]));
    popcount8 pc8_05 (.in(in[47:40]),   .out(pc8[5]));
    popcount8 pc8_06 (.in(in[55:48]),   .out(pc8[6]));
    popcount8 pc8_07 (.in(in[63:56]),   .out(pc8[7]));
    popcount8 pc8_08 (.in(in[71:64]),   .out(pc8[8]));
    popcount8 pc8_09 (.in(in[79:72]),   .out(pc8[9]));
    popcount8 pc8_10 (.in(in[87:80]),   .out(pc8[10]));
    popcount8 pc8_11 (.in(in[95:88]),   .out(pc8[11]));
    popcount8 pc8_12 (.in(in[103:96]),  .out(pc8[12]));
    popcount8 pc8_13 (.in(in[111:104]), .out(pc8[13]));
    popcount8 pc8_14 (.in(in[119:112]), .out(pc8[14]));
    popcount8 pc8_15 (.in(in[127:120]), .out(pc8[15]));
    popcount8 pc8_16 (.in(in[135:128]), .out(pc8[16]));
    popcount8 pc8_17 (.in(in[143:136]), .out(pc8[17]));
    popcount8 pc8_18 (.in(in[151:144]), .out(pc8[18]));
    popcount8 pc8_19 (.in(in[159:152]), .out(pc8[19]));
    popcount8 pc8_20 (.in(in[167:160]), .out(pc8[20]));
    popcount8 pc8_21 (.in(in[175:168]), .out(pc8[21]));
    popcount8 pc8_22 (.in(in[183:176]), .out(pc8[22]));
    popcount8 pc8_23 (.in(in[191:184]), .out(pc8[23]));
    popcount8 pc8_24 (.in(in[199:192]), .out(pc8[24]));
    popcount8 pc8_25 (.in(in[207:200]), .out(pc8[25]));
    popcount8 pc8_26 (.in(in[215:208]), .out(pc8[26]));
    popcount8 pc8_27 (.in(in[223:216]), .out(pc8[27]));
    popcount8 pc8_28 (.in(in[231:224]), .out(pc8[28]));
    popcount8 pc8_29 (.in(in[239:232]), .out(pc8[29]));
    popcount8 pc8_30 (.in(in[247:240]), .out(pc8[30]));

    // Pad last 7 bits with zero MSB to make 8 bits
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    popcount8 pc8_31 (.in(last_chunk), .out(pc8[31]));

    // Balanced tree summation of partial popcounts

    // Level 1: 16 sums (4-bit + 4-bit = 5-bit)
    wire [4:0] sum_l1 [15:0];
    assign sum_l1[0]  = pc8[0]  + pc8[1];
    assign sum_l1[1]  = pc8[2]  + pc8[3];
    assign sum_l1[2]  = pc8[4]  + pc8[5];
    assign sum_l1[3]  = pc8[6]  + pc8[7];
    assign sum_l1[4]  = pc8[8]  + pc8[9];
    assign sum_l1[5]  = pc8[10] + pc8[11];
    assign sum_l1[6]  = pc8[12] + pc8[13];
    assign sum_l1[7]  = pc8[14] + pc8[15];
    assign sum_l1[8]  = pc8[16] + pc8[17];
    assign sum_l1[9]  = pc8[18] + pc8[19];
    assign sum_l1[10] = pc8[20] + pc8[21];
    assign sum_l1[11] = pc8[22] + pc8[23];
    assign sum_l1[12] = pc8[24] + pc8[25];
    assign sum_l1[13] = pc8[26] + pc8[27];
    assign sum_l1[14] = pc8[28] + pc8[29];
    assign sum_l1[15] = pc8[30] + pc8[31];

    // Level 2: 8 sums (5-bit + 5-bit = 6-bit)
    wire [5:0] sum_l2 [7:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];
    assign sum_l2[4] = sum_l1[8] + sum_l1[9];
    assign sum_l2[5] = sum_l1[10] + sum_l1[11];
    assign sum_l2[6] = sum_l1[12] + sum_l1[13];
    assign sum_l2[7] = sum_l1[14] + sum_l1[15];

    // Level 3: 4 sums (6-bit + 6-bit = 7-bit)
    wire [6:0] sum_l3 [3:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];
    assign sum_l3[2] = sum_l2[4] + sum_l2[5];
    assign sum_l3[3] = sum_l2[6] + sum_l2[7];

    // Level 4: 2 sums (7-bit + 7-bit = 8-bit)
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: final sum (8-bit + 8-bit = 8-bit, max 255)
    assign out = sum_l4[0] + sum_l4[1];

endmodule