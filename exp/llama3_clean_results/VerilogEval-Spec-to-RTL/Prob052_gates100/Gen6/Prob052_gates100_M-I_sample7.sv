module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the 100-bit input vector into twenty 5-bit chunks
    wire [19:0] and_chunk;
    wire [19:0] or_chunk;
    wire [19:0] xor_chunk;

    // Perform AND, OR, and XOR operations on each 5-bit chunk
    genvar i;
    generate
        for (i = 0; i < 20; i++) begin
            assign and_chunk[i] = &in[(i * 5 + 4) : (i * 5)];
            assign or_chunk[i] = |in[(i * 5 + 4) : (i * 5)];
            assign xor_chunk[i] = ^in[(i * 5 + 4) : (i * 5)];
        end
    endgenerate

    // Combine the results from each chunk using the same logical operations
    assign out_and = &and_chunk;
    assign out_or = |or_chunk;
    assign out_xor = ^xor_chunk;

endmodule