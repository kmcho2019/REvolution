module popcount4(
    input  [3:0] in,
    output [2:0] out  // max count is 4, need 3 bits
);
    // Sum 4 bits directly using simple combinational logic
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount16(
    input  [15:0] in,
    output [4:0]  out  // max count 16, need 5 bits
);
    wire [2:0] pc4 [3:0]; // four 3-bit popcount4 outputs
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : pcs4
            popcount4 pc4_inst(.in(in[4*i +: 4]), .out(pc4[i]));
        end
    endgenerate

    // sum four 3-bit numbers (max 4*4=16)
    // intermediate sums use 5 bits width to hold max 16
    wire [4:0] sum01 = pc4[0] + pc4[1];
    wire [4:0] sum23 = pc4[2] + pc4[3];
    wire [4:0] sum_all = sum01 + sum23;

    assign out = sum_all;
endmodule

module add5(
    input  [4:0] a,
    input  [4:0] b,
    output [5:0] sum
);
    assign sum = a + b; // sum max 31, needs 6 bits
endmodule

module add6(
    input  [5:0] a,
    input  [5:0] b,
    output [6:0] sum
);
    assign sum = a + b; // sum max 63, needs 7 bits
endmodule

module add7(
    input  [6:0] a,
    input  [6:0] b,
    output [7:0] sum
);
    assign sum = a + b; // sum max 127, needs 8 bits
endmodule

module add8(
    input  [7:0] a,
    input  [4:0] b,
    output [7:0] sum
);
    // b is 5-bit number max 31, sum max 127+31=158 fits in 8 bits
    assign sum = a + b;
endmodule

module TopModule(
    input  [254:0] in,
    output [7:0]  out
);
    // Partition input into 16 groups of 16 bits and 1 extra bit
    wire [4:0] partial_counts [15:0]; // 16 groups, each 5 bits
    genvar gi;
    generate
        for (gi=0; gi<16; gi=gi+1) begin : pop16_groups
            popcount16 pc16(.in(in[gi*16 +:16]), .out(partial_counts[gi]));
        end
    endgenerate

    // The extra 255th bit partial count is 0 or 1
    wire [4:0] last_bit_count = {4'b0, in[254]}; // extend bit to 5 bits

    // Sum partial counts in a balanced binary tree:
    // Level 1: add pairs of 5-bit partial counts → 8 sums of 6 bits
    wire [5:0] sum_lv1 [7:0];
    generate
        for (gi=0; gi<8; gi=gi+1) begin : lv1_adders
            add5 add5_inst(.a(partial_counts[2*gi]), .b(partial_counts[2*gi+1]), .sum(sum_lv1[gi]));
        end
    endgenerate

    // Level 2: add pairs of 6-bit sums → 4 sums of 7 bits
    wire [6:0] sum_lv2 [3:0];
    generate
        for (gi=0; gi<4; gi=gi+1) begin : lv2_adders
            add6 add6_inst(.a(sum_lv1[2*gi]), .b(sum_lv1[2*gi+1]), .sum(sum_lv2[gi]));
        end
    endgenerate

    // Level 3: add pairs of 7-bit sums → 2 sums of 8 bits
    wire [7:0] sum_lv3 [1:0];
    generate
        for (gi=0; gi<2; gi=gi+1) begin : lv3_adders
            add7 add7_inst(.a(sum_lv2[2*gi]), .b(sum_lv2[2*gi+1]), .sum(sum_lv3[gi]));
        end
    endgenerate

    // Level 4: add the last two 8-bit sums → 8-bit sum (max 255)
    wire [7:0] sum_lv4;
    add8 add8_inst(.a(sum_lv3[0]), .b({3'b000, partial_counts[15]}), .sum(sum_lv4));

    // Add last_bit_count (5 bits) to sum_lv4 (8 bits)
    // max sum_lv4 ~ 127 + 16 = 143 (fits in 8 bits)
    wire [7:0] sum_lv5;
    add8 add8_last(.a(sum_lv4), .b(last_bit_count), .sum(sum_lv5));

    assign out = sum_lv5;
endmodule