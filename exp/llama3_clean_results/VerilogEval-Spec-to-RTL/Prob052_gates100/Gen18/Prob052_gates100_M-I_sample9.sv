module SegmentOperation(
    input [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // Divide the 25-bit segment into 5 5-bit segments
    wire [4:0] seg1, seg2, seg3, seg4, seg5;
    assign seg1 = in[4:0];
    assign seg2 = in[9:5];
    assign seg3 = in[14:10];
    assign seg4 = in[19:15];
    assign seg5 = in[24:20];

    // Perform operations on each 5-bit segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;
    wire and_seg5, or_seg5, xor_seg5;

    // AND Operation
    assign and_seg1 = &seg1;
    assign and_seg2 = &seg2;
    assign and_seg3 = &seg3;
    assign and_seg4 = &seg4;
    assign and_seg5 = &seg5;
    assign and_out = and_seg1 & and_seg2 & and_seg3 & and_seg4 & and_seg5;

    // OR Operation
    assign or_seg1 = |seg1;
    assign or_seg2 = |seg2;
    assign or_seg3 = |seg3;
    assign or_seg4 = |seg4;
    assign or_seg5 = |seg5;
    assign or_out = or_seg1 | or_seg2 | or_seg3 | or_seg4 | or_seg5;

    // XOR Operation
    assign xor_seg1 = ^seg1;
    assign xor_seg2 = ^seg2;
    assign xor_seg3 = ^seg3;
    assign xor_seg4 = ^seg4;
    assign xor_seg5 = ^seg5;
    assign xor_out = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4 ^ xor_seg5;

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