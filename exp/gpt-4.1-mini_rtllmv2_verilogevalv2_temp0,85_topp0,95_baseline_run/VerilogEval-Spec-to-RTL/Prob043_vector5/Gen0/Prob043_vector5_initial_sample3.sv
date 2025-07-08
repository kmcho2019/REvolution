module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;
    wire [24:0] cmp;

    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // index for output bit: (4 - i)*5 + (4 - j) if matching example
                // Given example: out[24] = ~a ^ a; out[23] = ~a ^ b; out[22] = ~a ^ c; ... down to out[0] = ~e ^ e.
                // So output index = 24 - (i*5 + j)
                assign cmp[24 - (i*5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate

    assign out = cmp;

endmodule