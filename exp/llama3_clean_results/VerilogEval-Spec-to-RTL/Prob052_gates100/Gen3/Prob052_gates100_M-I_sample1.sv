module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [3:0] and_chunk;
    wire [3:0] or_chunk;
    wire [3:0] xor_chunk;

    // Divide the 100-bit input vector into four 25-bit chunks
    assign and_chunk[0] = &in[24:0];
    assign and_chunk[1] = &in[49:25];
    assign and_chunk[2] = &in[74:50];
    assign and_chunk[3] = &in[99:75];

    assign or_chunk[0] = |in[24:0];
    assign or_chunk[1] = |in[49:25];
    assign or_chunk[2] = |in[74:50];
    assign or_chunk[3] = |in[99:75];

    assign xor_chunk[0] = ^in[24:0];
    assign xor_chunk[1] = ^in[49:25];
    assign xor_chunk[2] = ^in[74:50];
    assign xor_chunk[3] = ^in[99:75];

    // Combine the results from each chunk using the same logical operations
    assign out_and = &and_chunk;
    assign out_or = |or_chunk;
    assign out_xor = ^xor_chunk;

endmodule