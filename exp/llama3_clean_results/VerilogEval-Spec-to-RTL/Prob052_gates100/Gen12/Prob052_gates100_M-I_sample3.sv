module ChunkOperation(
    input [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    wire and1, and2, and3, and4;
    wire or1, or2, or3, or4;
    wire xor1, xor2, xor3, xor4;

    assign and1 = in[0] & in[1];
    assign and2 = in[2] & in[3];
    assign and3 = in[4] & in[5];
    assign and4 = in[6] & in[7];

    assign or1 = in[0] | in[1];
    assign or2 = in[2] | in[3];
    assign or3 = in[4] | in[5];
    assign or4 = in[6] | in[7];

    assign xor1 = in[0] ^ in[1];
    assign xor2 = in[2] ^ in[3];
    assign xor3 = in[4] ^ in[5];
    assign xor4 = in[6] ^ in[7];

    assign and_out = and1 & and2 & and3 & and4 & in[8] & in[9];
    assign or_out = or1 | or2 | or3 | or4 | in[8] | in[9];
    assign xor_out = xor1 ^ xor2 ^ xor3 ^ xor4 ^ in[8] ^ in[9];

endmodule

module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into five 20-bit chunks
    wire [19:0] chunk1;
    wire [19:0] chunk2;
    wire [19:0] chunk3;
    wire [19:0] chunk4;
    wire [19:0] chunk5;

    assign chunk1 = in[19:0];
    assign chunk2 = in[39:20];
    assign chunk3 = in[59:40];
    assign chunk4 = in[79:60];
    assign chunk5 = in[99:80];

    // Perform operations on each chunk
    wire and_chunk1, or_chunk1, xor_chunk1;
    wire and_chunk2, or_chunk2, xor_chunk2;
    wire and_chunk3, or_chunk3, xor_chunk3;
    wire and_chunk4, or_chunk4, xor_chunk4;
    wire and_chunk5, or_chunk5, xor_chunk5;

    // Create sub-chunks for each 20-bit chunk
    wire [9:0] sub_chunk1_1, sub_chunk1_2;
    wire [9:0] sub_chunk2_1, sub_chunk2_2;
    wire [9:0] sub_chunk3_1, sub_chunk3_2;
    wire [9:0] sub_chunk4_1, sub_chunk4_2;
    wire [9:0] sub_chunk5_1, sub_chunk5_2;

    assign sub_chunk1_1 = chunk1[9:0];
    assign sub_chunk1_2 = chunk1[19:10];
    assign sub_chunk2_1 = chunk2[9:0];
    assign sub_chunk2_2 = chunk2[19:10];
    assign sub_chunk3_1 = chunk3[9:0];
    assign sub_chunk3_2 = chunk3[19:10];
    assign sub_chunk4_1 = chunk4[9:0];
    assign sub_chunk4_2 = chunk4[19:10];
    assign sub_chunk5_1 = chunk5[9:0];
    assign sub_chunk5_2 = chunk5[19:10];

    wire and_sub_chunk1_1, or_sub_chunk1_1, xor_sub_chunk1_1;
    wire and_sub_chunk1_2, or_sub_chunk1_2, xor_sub_chunk1_2;
    wire and_sub_chunk2_1, or_sub_chunk2_1, xor_sub_chunk2_1;
    wire and_sub_chunk2_2, or_sub_chunk2_2, xor_sub_chunk2_2;
    wire and_sub_chunk3_1, or_sub_chunk3_1, xor_sub_chunk3_1;
    wire and_sub_chunk3_2, or_sub_chunk3_2, xor_sub_chunk3_2;
    wire and_sub_chunk4_1, or_sub_chunk4_1, xor_sub_chunk4_1;
    wire and_sub_chunk4_2, or_sub_chunk4_2, xor_sub_chunk4_2;
    wire and_sub_chunk5_1, or_sub_chunk5_1, xor_sub_chunk5_1;
    wire and_sub_chunk5_2, or_sub_chunk5_2, xor_sub_chunk5_2;

    ChunkOperation sub_chunk1_1_op(sub_chunk1_1, and_sub_chunk1_1, or_sub_chunk1_1, xor_sub_chunk1_1);
    ChunkOperation sub_chunk1_2_op(sub_chunk1_2, and_sub_chunk1_2, or_sub_chunk1_2, xor_sub_chunk1_2);
    ChunkOperation sub_chunk2_1_op(sub_chunk2_1, and_sub_chunk2_1, or_sub_chunk2_1, xor_sub_chunk2_1);
    ChunkOperation sub_chunk2_2_op(sub_chunk2_2, and_sub_chunk2_2, or_sub_chunk2_2, xor_sub_chunk2_2);
    ChunkOperation sub_chunk3_1_op(sub_chunk3_1, and_sub_chunk3_1, or_sub_chunk3_1, xor_sub_chunk3_1);
    ChunkOperation sub_chunk3_2_op(sub_chunk3_2, and_sub_chunk3_2, or_sub_chunk3_2, xor_sub_chunk3_2);
    ChunkOperation sub_chunk4_1_op(sub_chunk4_1, and_sub_chunk4_1, or_sub_chunk4_1, xor_sub_chunk4_1);
    ChunkOperation sub_chunk4_2_op(sub_chunk4_2, and_sub_chunk4_2, or_sub_chunk4_2, xor_sub_chunk4_2);
    ChunkOperation sub_chunk5_1_op(sub_chunk5_1, and_sub_chunk5_1, or_sub_chunk5_1, xor_sub_chunk5_1);
    ChunkOperation sub_chunk5_2_op(sub_chunk5_2, and_sub_chunk5_2, or_sub_chunk5_2, xor_sub_chunk5_2);

    assign and_chunk1 = and_sub_chunk1_1 & and_sub_chunk1_2;
    assign or_chunk1 = or_sub_chunk1_1 | or_sub_chunk1_2;
    assign xor_chunk1 = xor_sub_chunk1_1 ^ xor_sub_chunk1_2;

    assign and_chunk2 = and_sub_chunk2_1 & and_sub_chunk2_2;
    assign or_chunk2 = or_sub_chunk2_1 | or_sub_chunk2_2;
    assign xor_chunk2 = xor_sub_chunk2_1 ^ xor_sub_chunk2_2;

    assign and_chunk3 = and_sub_chunk3_1 & and_sub_chunk3_2;
    assign or_chunk3 = or_sub_chunk3_1 | or_sub_chunk3_2;
    assign xor_chunk3 = xor_sub_chunk3_1 ^ xor_sub_chunk3_2;

    assign and_chunk4 = and_sub_chunk4_1 & and_sub_chunk4_2;
    assign or_chunk4 = or_sub_chunk4_1 | or_sub_chunk4_2;
    assign xor_chunk4 = xor_sub_chunk4_1 ^ xor_sub_chunk4_2;

    assign and_chunk5 = and_sub_chunk5_1 & and_sub_chunk5_2;
    assign or_chunk5 = or_sub_chunk5_1 | or_sub_chunk5_2;
    assign xor_chunk5 = xor_sub_chunk5_1 ^ xor_sub_chunk5_2;

    // Combine the results from each chunk
    assign out_and = and_chunk1 & and_chunk2 & and_chunk3 & and_chunk4 & and_chunk5;
    assign out_or = or_chunk1 | or_chunk2 | or_chunk3 | or_chunk4 | or_chunk5;
    assign out_xor = xor_chunk1 ^ xor_chunk2 ^ xor_chunk3 ^ xor_chunk4 ^ xor_chunk5;

endmodule