module ChunkOperation(
    input  [49:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &in;
    assign or_out = |in;
    assign xor_out = ^in;

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

    ChunkOperation chunk0(.in(in[49:0]),.and_out(and_result0),.or_out(or_result0),.xor_out(xor_result0));
    ChunkOperation chunk1(.in(in[99:50]),.and_out(and_result1),.or_out(or_result1),.xor_out(xor_result1));

    assign out_and = and_result0 & and_result1;
    assign out_or = or_result0 | or_result1;
    assign out_xor = xor_result0 ^ xor_result1;

endmodule