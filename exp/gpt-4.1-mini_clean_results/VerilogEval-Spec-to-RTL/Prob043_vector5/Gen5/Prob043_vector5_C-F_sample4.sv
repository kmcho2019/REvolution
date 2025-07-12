module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into a 5-bit vector for synthesis friendliness:
    // inputs[4] = a, inputs[3] = b, ..., inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Map (i,j) pairs to output bits [24 down to 0] in row-major order:
                // out[24] = compare a,a = inputs[4], inputs[4]
                // out[23] = compare a,b = inputs[4], inputs[3], etc.
                // To match out[24 - (5*i + j)] with inputs indexed 4-i and 4-j:
                assign out[24 - (5*i + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate

endmodule