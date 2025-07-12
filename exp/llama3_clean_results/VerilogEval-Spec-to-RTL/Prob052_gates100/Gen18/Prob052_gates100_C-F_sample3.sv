module SegmentOperation(
    input [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    wire [11:0] and_tree;
    assign and_tree[0] = in[0];
    assign and_tree[1] = in[1] & in[0];
    assign and_tree[2] = in[2] & and_tree[1];
    assign and_tree[3] = in[3] & and_tree[2];
    assign and_tree[4] = in[4] & and_tree[3];
    assign and_tree[5] = in[5] & and_tree[4];
    assign and_tree[6] = in[6] & and_tree[5];
    assign and_tree[7] = in[7] & and_tree[6];
    assign and_tree[8] = in[8] & and_tree[7];
    assign and_tree[9] = in[9] & and_tree[8];
    assign and_tree[10] = in[10] & and_tree[9];
    assign and_tree[11] = in[11] & and_tree[10];
    assign and_out = in[24] & in[23] & in[22] & in[21] & in[20] & in[19] & in[18] & in[17] & in[16] & in[15] & in[14] & in[13] & in[12] & and_tree[11];

    // OR Operation
    wire [11:0] or_tree;
    assign or_tree[0] = in[0];
    assign or_tree[1] = in[1] | in[0];
    assign or_tree[2] = in[2] | or_tree[1];
    assign or_tree[3] = in[3] | or_tree[2];
    assign or_tree[4] = in[4] | or_tree[3];
    assign or_tree[5] = in[5] | or_tree[4];
    assign or_tree[6] = in[6] | or_tree[5];
    assign or_tree[7] = in[7] | or_tree[6];
    assign or_tree[8] = in[8] | or_tree[7];
    assign or_tree[9] = in[9] | or_tree[8];
    assign or_tree[10] = in[10] | or_tree[9];
    assign or_tree[11] = in[11] | or_tree[10];
    assign or_out = in[24] | in[23] | in[22] | in[21] | in[20] | in[19] | in[18] | in[17] | in[16] | in[15] | in[14] | in[13] | in[12] | or_tree[11];

    // XOR Operation
    wire [11:0] xor_tree;
    assign xor_tree[0] = in[0];
    assign xor_tree[1] = in[1] ^ in[0];
    assign xor_tree[2] = in[2] ^ xor_tree[1];
    assign xor_tree[3] = in[3] ^ xor_tree[2];
    assign xor_tree[4] = in[4] ^ xor_tree[3];
    assign xor_tree[5] = in[5] ^ xor_tree[4];
    assign xor_tree[6] = in[6] ^ xor_tree[5];
    assign xor_tree[7] = in[7] ^ xor_tree[6];
    assign xor_tree[8] = in[8] ^ xor_tree[7];
    assign xor_tree[9] = in[9] ^ xor_tree[8];
    assign xor_tree[10] = in[10] ^ xor_tree[9];
    assign xor_tree[11] = in[11] ^ xor_tree[10];
    assign xor_out = in[24] ^ in[23] ^ in[22] ^ in[21] ^ in[20] ^ in[19] ^ in[18] ^ in[17] ^ in[16] ^ in[15] ^ in[14] ^ in[13] ^ in[12] ^ xor_tree[11];

endmodule

module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into four 25-bit segments
    wire [24:0] seg1;
    wire [24:0] seg2;
    wire [24:0] seg3;
    wire [24:0] seg4;

    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    // Perform operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;

    SegmentOperation seg1_op(seg1, and_seg1, or_seg1, xor_seg1);
    SegmentOperation seg2_op(seg2, and_seg2, or_seg2, xor_seg2);
    SegmentOperation seg3_op(seg3, and_seg3, or_seg3, xor_seg3);
    SegmentOperation seg4_op(seg4, and_seg4, or_seg4, xor_seg4);

    // Combine the results from each segment
    assign out_and = and_seg1 & and_seg2 & and_seg3 & and_seg4;
    assign out_or = or_seg1 | or_seg2 | or_seg3 | or_seg4;
    assign out_xor = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4;

endmodule