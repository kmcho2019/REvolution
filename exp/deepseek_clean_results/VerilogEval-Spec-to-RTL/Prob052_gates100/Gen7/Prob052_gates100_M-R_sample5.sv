module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate results for AND operation
    wire [99:0] and_intermediate;
    assign and_intermediate[0] = in[0];
    genvar i;
    generate
        for (i = 1; i < 100; i = i + 1) begin : and_chain
            assign and_intermediate[i] = and_intermediate[i-1] & in[i];
        end
    endgenerate
    assign out_and = and_intermediate[99];

    // Intermediate results for OR operation
    wire [99:0] or_intermediate;
    assign or_intermediate[0] = in[0];
    genvar j;
    generate
        for (j = 1; j < 100; j = j + 1) begin : or_chain
            assign or_intermediate[j] = or_intermediate[j-1] | in[j];
        end
    endgenerate
    assign out_or = or_intermediate[99];

    // Intermediate results for XOR operation
    wire [99:0] xor_intermediate;
    assign xor_intermediate[0] = in[0];
    genvar k;
    generate
        for (k = 1; k < 100; k = k + 1) begin : xor_chain
            assign xor_intermediate[k] = xor_intermediate[k-1] ^ in[k];
        end
    endgenerate
    assign out_xor = xor_intermediate[99];

endmodule