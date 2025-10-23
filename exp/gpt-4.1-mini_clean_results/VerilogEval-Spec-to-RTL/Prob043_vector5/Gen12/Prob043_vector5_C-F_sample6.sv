module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for easy indexed access:
    // inputs[4] = a, inputs[3] = b, ..., inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Each bit out[24 - (5*i + j)] corresponds to comparing inputs[4 - i] vs inputs[4 - j]
                // Result is 1 if bits are equal (XNOR)
                assign out[24 - (5*i + j)] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

endmodule