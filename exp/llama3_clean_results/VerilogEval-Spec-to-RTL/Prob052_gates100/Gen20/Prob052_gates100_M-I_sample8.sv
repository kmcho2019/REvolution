module SegmentOperation(
    input [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation using tree structure
    wire and_tree1, and_tree2, and_tree3, and_tree4;
    assign and_tree1 = in[0] & in[1] & in[2] & in[3] & in[4];
    assign and_tree2 = in[5] & in[6] & in[7] & in[8] & in[9];
    assign and_tree3 = in[10] & in[11] & in[12] & in[13] & in[14];
    assign and_tree4 = in[15] & in[16] & in[17] & in[18] & in[19];
    assign and_out = and_tree1 & and_tree2 & and_tree3 & and_tree4 & in[24] & in[23] & in[22] & in[21] & in[20];

    // OR Operation using tree structure
    wire or_tree1, or_tree2, or_tree3, or_tree4;
    assign or_tree1 = in[0] | in[1] | in[2] | in[3] | in[4];
    assign or_tree2 = in[5] | in[6] | in[7] | in[8] | in[9];
    assign or_tree3 = in[10] | in[11] | in[12] | in[13] | in[14];
    assign or_tree4 = in[15] | in[16] | in[17] | in[18] | in[19];
    assign or_out = or_tree1 | or_tree2 | or_tree3 | or_tree4 | in[24] | in[23] | in[22] | in[21] | in[20];

    // XOR Operation using tree structure
    wire xor_tree1, xor_tree2, xor_tree3, xor_tree4;
    assign xor_tree1 = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4];
    assign xor_tree2 = in[5] ^ in[6] ^ in[7] ^ in[8] ^ in[9];
    assign xor_tree3 = in[10] ^ in[11] ^ in[12] ^ in[13] ^ in[14];
    assign xor_tree4 = in[15] ^ in[16] ^ in[17] ^ in[18] ^ in[19];
    assign xor_out = xor_tree1 ^ xor_tree2 ^ xor_tree3 ^ xor_tree4 ^ in[24] ^ in[23] ^ in[22] ^ in[21] ^ in[20];

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