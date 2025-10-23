module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the 100-bit input vector into 4 chunks of 25 bits each
    wire [3:0] and_chunk;
    wire [3:0] or_chunk;
    wire [3:0] xor_chunk;

    // Perform the AND, OR, and XOR operations on each chunk in parallel
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin
            assign and_chunk[i] = &in[(i * 25) + 24 : i * 25];
            assign or_chunk[i] = |in[(i * 25) + 24 : i * 25];
            assign xor_chunk[i] = ^in[(i * 25) + 24 : i * 25];
        end
    endgenerate

    // Combine the results from each chunk using the same logical operations
    assign out_and = &and_chunk;
    assign out_or = |or_chunk;
    assign out_xor = ^xor_chunk;

endmodule