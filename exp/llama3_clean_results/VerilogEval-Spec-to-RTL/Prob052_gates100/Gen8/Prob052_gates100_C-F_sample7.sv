module SegmentOperation(
    input [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // Use tree structures for AND, OR, and XOR operations
    wire and_chunk1, and_chunk2, and_chunk3, and_chunk4;
    wire or_chunk1, or_chunk2, or_chunk3, or_chunk4;
    wire xor_chunk1, xor_chunk2, xor_chunk3, xor_chunk4;

    assign and_chunk1 = (in[0] & in[1] & in[2] & in[3] & in[4] & in[5]);
    assign and_chunk2 = (in[6] & in[7] & in[8] & in[9] & in[10] & in[11]);
    assign and_chunk3 = (in[12] & in[13] & in[14] & in[15] & in[16] & in[17]);
    assign and_chunk4 = (in[18] & in[19] & in[20] & in[21] & in[22] & in[23] & in[24]);

    assign or_chunk1 = (in[0] | in[1] | in[2] | in[3] | in[4] | in[5]);
    assign or_chunk2 = (in[6] | in[7] | in[8] | in[9] | in[10] | in[11]);
    assign or_chunk3 = (in[12] | in[13] | in[14] | in[15] | in[16] | in[17]);
    assign or_chunk4 = (in[18] | in[19] | in[20] | in[21] | in[22] | in[23] | in[24]);

    assign xor_chunk1 = (in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5]);
    assign xor_chunk2 = (in[6] ^ in[7] ^ in[8] ^ in[9] ^ in[10] ^ in[11]);
    assign xor_chunk3 = (in[12] ^ in[13] ^ in[14] ^ in[15] ^ in[16] ^ in[17]);
    assign xor_chunk4 = (in[18] ^ in[19] ^ in[20] ^ in[21] ^ in[22] ^ in[23] ^ in[24]);

    assign and_out = (and_chunk1 & and_chunk2 & and_chunk3 & and_chunk4);
    assign or_out = (or_chunk1 | or_chunk2 | or_chunk3 | or_chunk4);
    assign xor_out = (xor_chunk1 ^ xor_chunk2 ^ xor_chunk3 ^ xor_chunk4);

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
    assign out_and = (and_seg1 & and_seg2 & and_seg3 & and_seg4);
    assign out_or = (or_seg1 | or_seg2 | or_seg3 | or_seg4);
    assign out_xor = (xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4);

endmodule