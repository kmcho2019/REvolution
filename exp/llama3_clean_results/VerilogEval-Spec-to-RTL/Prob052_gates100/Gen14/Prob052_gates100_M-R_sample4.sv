module ChunkOperation(
    input  [9:0] in,
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

    wire [9:0] and_results;
    wire [9:0] or_results;
    wire [9:0] xor_results;

    genvar i;
    for (i = 0; i < 10; i++) begin
        ChunkOperation chunk(
           .in(in[(i+1)*10-1:i*10]),
           .and_out(and_results[i]),
           .or_out(or_results[i]),
           .xor_out(xor_results[i])
        );
    end

    assign out_and = &and_results;
    assign out_or = |or_results;
    assign out_xor = ^xor_results;

endmodule