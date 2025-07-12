module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Partial results for each 10-bit chunk
    wire [9:0] partial_and;
    wire [9:0] partial_or;
    wire [9:0] partial_xor;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_reduction
            assign partial_and[i] = &in[i*10 +: 10];
            assign partial_or[i]  = |in[i*10 +: 10];
            assign partial_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Final outputs by reducing the partial results
    assign out_and = &partial_and;
    assign out_or  = |partial_or;
    assign out_xor = ^partial_xor;

endmodule