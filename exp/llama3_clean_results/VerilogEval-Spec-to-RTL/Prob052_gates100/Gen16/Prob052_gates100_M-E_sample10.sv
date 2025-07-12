module ChunkOperation(
    input  [7:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &(in);
    assign or_out = |in;
    assign xor_out = ^in;

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide into 12 chunks of 8 bits each, with 4 bits leftover
    wire [11:0] and_chunk;
    wire [11:0] or_chunk;
    wire [11:0] xor_chunk;

    // Perform operations on each chunk
    genvar i;
    generate
        for (i = 0; i < 12; i++) begin
            ChunkOperation chunk(
                .in(in[(i*8)+7:(i*8)]),
                .and_out(and_chunk[i]),
                .or_out(or_chunk[i]),
                .xor_out(xor_chunk[i])
            );
        end
    endgenerate

    // Handle leftover 4 bits directly
    wire and_leftover;
    wire or_leftover;
    wire xor_leftover;

    assign and_leftover = &(in[99:96]);
    assign or_leftover = |in[99:96];
    assign xor_leftover = ^in[99:96];

    // Final reduction
    assign out_and = &(and_chunk) & and_leftover;
    assign out_or = |or_chunk | or_leftover;
    assign out_xor = ^(xor_chunk) ^ xor_leftover;

endmodule