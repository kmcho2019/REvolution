module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Create array of inputs for convenience
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin: row
            for (j = 0; j < 5; j = j + 1) begin: col
                // Compute equality and assign to output bit
                // The bit index is (4 - i)*5 + (4 - j) to match example (bit 24 for (a,a))
                // But example shows out[24] = ~(a^a), out[23] = ~(a^b), ..., out[0] = ~(e^e)
                // So bit index = (4 - i)*5 + (4 - j)
                assign out[(4 - i)*5 + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule