module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate results for each 10-bit chunk
    wire [9:0] and_intermediate;
    wire [9:0] or_intermediate;
    wire [9:0] xor_intermediate;

    // First level: Reduce 10-bit chunks
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : reduction
            assign and_intermediate[i] = &in[i*10 +: 10];
            assign or_intermediate[i]  = |in[i*10 +: 10];
            assign xor_intermediate[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second level: Final reduction
    assign out_and = &and_intermediate;
    assign out_or  = |or_intermediate;
    assign out_xor = ^xor_intermediate;

endmodule