module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    wire [2:0] sum_lo, sum_hi;

    // Sum lower 4 bits
    assign sum_lo = in[0] + in[1] + in[2] + in[3];

    // Sum upper 4 bits
    assign sum_hi = in[4] + in[5] + in[6] + in[7];

    // Combine
    assign out = sum_lo + sum_hi;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 32 popcount8 modules for each 8-bit segment
    // Last segment padded with zero MSB
    wire [3:0] pc8 [31:0];

    popcount8 pc_inst0  (.in(in[7:0]),     .out(pc8[0]));
    popcount8 pc_inst1  (.in(in[15:8]),    .out(pc8[1]));
    popcount8 pc_inst2  (.in(in[23:16]),   .out(pc8[2]));
    popcount8 pc_inst3  (.in(in[31:24]),   .out(pc8[3]));
    popcount8 pc_inst4  (.in(in[39:32]),   .out(pc8[4]));
    popcount8 pc_inst5  (.in(in[47:40]),   .out(pc8[5]));
    popcount8 pc_inst6  (.in(in[55:48]),   .out(pc8[6]));
    popcount8 pc_inst7  (.in(in[63:56]),   .out(pc8[7]));
    popcount8 pc_inst8  (.in(in[71:64]),   .out(pc8[8]));
    popcount8 pc_inst9  (.in(in[79:72]),   .out(pc8[9]));
    popcount8 pc_inst10 (.in(in[87:80]),   .out(pc8[10]));
    popcount8 pc_inst11 (.in(in[95:88]),   .out(pc8[11]));
    popcount8 pc_inst12 (.in(in[103:96]),  .out(pc8[12]));
    popcount8 pc_inst13 (.in(in[111:104]), .out(pc8[13]));
    popcount8 pc_inst14 (.in(in[119:112]), .out(pc8[14]));
    popcount8 pc_inst15 (.in(in[127:120]), .out(pc8[15]));
    popcount8 pc_inst16 (.in(in[135:128]), .out(pc8[16]));
    popcount8 pc_inst17 (.in(in[143:136]), .out(pc8[17]));
    popcount8 pc_inst18 (.in(in[151:144]), .out(pc8[18]));
    popcount8 pc_inst19 (.in(in[159:152]), .out(pc8[19]));
    popcount8 pc_inst20 (.in(in[167:160]), .out(pc8[20]));
    popcount8 pc_inst21 (.in(in[175:168]), .out(pc8[21]));
    popcount8 pc_inst22 (.in(in[183:176]), .out(pc8[22]));
    popcount8 pc_inst23 (.in(in[191:184]), .out(pc8[23]));
    popcount8 pc_inst24 (.in(in[199:192]), .out(pc8[24]));
    popcount8 pc_inst25 (.in(in[207:200]), .out(pc8[25]));
    popcount8 pc_inst26 (.in(in[215:208]), .out(pc8[26]));
    popcount8 pc_inst27 (.in(in[223:216]), .out(pc8[27]));
    popcount8 pc_inst28 (.in(in[231:224]), .out(pc8[28]));
    popcount8 pc_inst29 (.in(in[239:232]), .out(pc8[29]));
    popcount8 pc_inst30 (.in(in[247:240]), .out(pc8[30]));
    // Last 7 bits padded with zero MSB
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    popcount8 pc_inst31 (.in(last_chunk),  .out(pc8[31]));

    // Balanced summation tree:
    // Level 1: 16 sums of two 4-bit numbers (pc8 outputs), result 5 bits
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

    // Level 2: 8 sums of two 5-bit numbers, result 6 bits
    wire [5:0] sum_l2 [7:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];
    assign sum_l2[4] = sum_l1[8] + sum_l1[9];
    assign sum_l2[5] = sum_l1[10] + sum_l1[11];
    assign sum_l2[6] = sum_l1[12] + sum_l1[13];
    assign sum_l2[7] = sum_l1[14] + sum_l1[15];

    // Level 3: 4 sums of two 6-bit numbers, result 7 bits
    wire [6:0] sum_l3 [3:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];
    assign sum_l3[2] = sum_l2[4] + sum_l2[5];
    assign sum_l3[3] = sum_l2[6] + sum_l2[7];

    // Level 4: 2 sums of two 7-bit numbers, result 8 bits
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: final sum of two 8-bit numbers, result 8 bits (max count is 255)
    assign out = sum_l4[0] + sum_l4[1];
endmodule