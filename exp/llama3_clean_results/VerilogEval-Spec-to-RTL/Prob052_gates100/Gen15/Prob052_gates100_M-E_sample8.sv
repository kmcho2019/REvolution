module PipelineStage(
    input  [24:0] in,
    input  and_in,
    input  or_in,
    input  xor_in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    assign and_out = in[24] & in[23] & in[22] & in[21] & in[20] & in[19] & in[18] & in[17] & in[16] & in[15] & in[14] & in[13] & in[12] & in[11] & in[10] & in[9] & in[8] & in[7] & in[6] & in[5] & in[4] & in[3] & in[2] & in[1] & in[0] & and_in;

    // OR Operation
    assign or_out = in[24] | in[23] | in[22] | in[21] | in[20] | in[19] | in[18] | in[17] | in[16] | in[15] | in[14] | in[13] | in[12] | in[11] | in[10] | in[9] | in[8] | in[7] | in[6] | in[5] | in[4] | in[3] | in[2] | in[1] | in[0] | or_in;

    // XOR Operation
    assign xor_out = in[24] ^ in[23] ^ in[22] ^ in[21] ^ in[20] ^ in[19] ^ in[18] ^ in[17] ^ in[16] ^ in[15] ^ in[14] ^ in[13] ^ in[12] ^ in[11] ^ in[10] ^ in[9] ^ in[8] ^ in[7] ^ in[6] ^ in[5] ^ in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0] ^ xor_in;

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

    PipelineStage stage0(.in(in[24:0]),.and_in(1'b1),.or_in(1'b0),.xor_in(1'b0),.and_out(and_result0),.or_out(or_result0),.xor_out(xor_result0));
    PipelineStage stage1(.in(in[49:25]),.and_in(and_result0),.or_in(or_result0),.xor_in(xor_result0),.and_out(and_result1),.or_out(or_result1),.xor_out(xor_result1));
    PipelineStage stage2(.in(in[74:50]),.and_in(and_result1),.or_in(or_result1),.xor_in(xor_result1),.and_out(and_result2),.or_out(or_result2),.xor_out(xor_result2));
    PipelineStage stage3(.in(in[99:75]),.and_in(and_result2),.or_in(or_result2),.xor_in(xor_result2),.and_out(and_result3),.or_out(or_result3),.xor_out(xor_result3));

    assign out_and = and_result3;
    assign out_or = or_result3;
    assign out_xor = xor_result3;

endmodule