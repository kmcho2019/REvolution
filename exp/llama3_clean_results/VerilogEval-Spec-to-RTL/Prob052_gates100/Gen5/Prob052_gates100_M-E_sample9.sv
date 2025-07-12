module ChunkOperation(
    input  [24:0] in,
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

    wire [3:0] and_results;
    wire [3:0] or_results;
    wire [3:0] xor_results;

    ChunkOperation chunk0(.in(in[24:0]), .and_out(and_results[0]), .or_out(or_results[0]), .xor_out(xor_results[0]));
    ChunkOperation chunk1(.in(in[49:25]), .and_out(and_results[1]), .or_out(or_results[1]), .xor_out(xor_results[1]));
    ChunkOperation chunk2(.in(in[74:50]), .and_out(and_results[2]), .or_out(or_results[2]), .xor_out(xor_results[2]));
    ChunkOperation chunk3(.in(in[99:75]), .and_out(and_results[3]), .or_out(or_results[3]), .xor_out(xor_results[3]));

    assign out_and = &and_results;
    assign out_or = |or_results;
    assign out_xor = ^xor_results;

endmodule