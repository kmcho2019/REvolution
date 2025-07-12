module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    // Divide the input vector into chunks
    wire chunk1 = in[7] | in[6] | in[5] | in[4];
    wire chunk2 = in[3] | in[2] | in[1] | in[0];

    // Identify which chunk contains the first '1' bit
    wire chunk1_first = chunk1 & ~chunk2;

    // Narrow down the search within the identified chunk
    wire pos_7_4 = chunk1_first ? (in[7] ? 3'd7 : (in[6] ? 3'd6 : (in[5] ? 3'd5 : (in[4] ? 3'd4 : 3'd0))) : 3'd0;
    wire pos_3_0 = ~chunk1_first ? (in[3] ? 3'd3 : (in[2] ? 3'd2 : (in[1] ? 3'd1 : (in[0] ? 3'd0 : 3'd0))) : 3'd0;

    // Encode the priority
    assign pos = pos_7_4 | pos_3_0;

endmodule