module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [19:0] and_chunk;
    wire [19:0] or_chunk;
    wire [19:0] xor_chunk;

    // Divide the 100-bit input vector into 20 chunks of 5 bits each
    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin
            assign and_chunk[i] = &in[(i * 5) + 4 : i * 5];
            assign or_chunk[i] = |in[(i * 5) + 4 : i * 5];
            assign xor_chunk[i] = ^in[(i * 5) + 4 : i * 5];
        end
    endgenerate

    // Combine the results from each chunk using the same logical operations
    assign out_and = &and_chunk;
    assign out_or = |or_chunk;
    assign out_xor = ^xor_chunk;

endmodule