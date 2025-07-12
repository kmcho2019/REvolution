module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_chunk0;
    wire and_chunk1;
    wire and_chunk2;
    wire and_chunk3;

    wire or_chunk0;
    wire or_chunk1;
    wire or_chunk2;
    wire or_chunk3;

    wire xor_chunk0;
    wire xor_chunk1;
    wire xor_chunk2;
    wire xor_chunk3;

    assign and_chunk0 = &in[24:0];
    assign and_chunk1 = &in[49:25];
    assign and_chunk2 = &in[74:50];
    assign and_chunk3 = &in[99:75];

    assign or_chunk0 = |in[24:0];
    assign or_chunk1 = |in[49:25];
    assign or_chunk2 = |in[74:50];
    assign or_chunk3 = |in[99:75];

    assign xor_chunk0 = ^in[24:0];
    assign xor_chunk1 = ^in[49:25];
    assign xor_chunk2 = ^in[74:50];
    assign xor_chunk3 = ^in[99:75];

    assign out_and = and_chunk0 & and_chunk1 & and_chunk2 & and_chunk3;
    assign out_or  = or_chunk0 | or_chunk1 | or_chunk2 | or_chunk3;
    assign out_xor = xor_chunk0 ^ xor_chunk1 ^ xor_chunk2 ^ xor_chunk3;

endmodule