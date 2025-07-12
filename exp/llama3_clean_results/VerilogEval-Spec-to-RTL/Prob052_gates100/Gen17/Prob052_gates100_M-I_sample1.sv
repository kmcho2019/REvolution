module TreeOperation(
    input  [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    assign and_out = in[24] & in[23] & in[22] & in[21] & in[20] & in[19] & in[18] & in[17] & in[16] & in[15] & in[14] & in[13] & in[12] & in[11] & in[10] & in[9] & in[8] & in[7] & in[6] & in[5] & in[4] & in[3] & in[2] & in[1] & in[0];

    // OR Operation
    assign or_out = in[24] | in[23] | in[22] | in[21] | in[20] | in[19] | in[18] | in[17] | in[16] | in[15] | in[14] | in[13] | in[12] | in[11] | in[10] | in[9] | in[8] | in[7] | in[6] | in[5] | in[4] | in[3] | in[2] | in[1] | in[0];

    // XOR Operation
    assign xor_out = in[24] ^ in[23] ^ in[22] ^ in[21] ^ in[20] ^ in[19] ^ in[18] ^ in[17] ^ in[16] ^ in[15] ^ in[14] ^ in[13] ^ in[12] ^ in[11] ^ in[10] ^ in[9] ^ in[8] ^ in[7] ^ in[6] ^ in[5] ^ in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_result0;
    wire or_result0;
    wire xor_result0;
    wire and_result1;
    wire or_result1;
    wire xor_result1;
    wire and_result2;
    wire or_result2;
    wire xor_result2;
    wire and_result3;
    wire or_result3;
    wire xor_result3;

    TreeOperation chunk0(.in(in[24:0]),.and_out(and_result0),.or_out(or_result0),.xor_out(xor_result0));
    TreeOperation chunk1(.in(in[49:25]),.and_out(and_result1),.or_out(or_result1),.xor_out(xor_result1));
    TreeOperation chunk2(.in(in[74:50]),.and_out(and_result2),.or_out(or_result2),.xor_out(xor_result2));
    TreeOperation chunk3(.in(in[99:75]),.and_out(and_result3),.or_out(or_result3),.xor_out(xor_result3));

    assign out_and = and_result0 & and_result1 & and_result2 & and_result3;
    assign out_or = or_result0 | or_result1 | or_result2 | or_result3;
    assign out_xor = xor_result0 ^ xor_result1 ^ xor_result2 ^ xor_result3;

endmodule