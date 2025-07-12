module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access:
    // inputs[4] = a, inputs[3] = b, inputs[2] = c, inputs[1] = d, inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_comp
            // Calculate row (i) and column (j) from linear index idx:
            // idx = 5*i + j
            // Map inputs with indices reversed (4 - i and 4 - j) per problem statement.
            wire [2:0] i = idx / 5;
            wire [2:0] j = idx % 5;
            // Assign output bit at position [24 - idx]:
            // output bit is 1 if inputs[4 - i] equals inputs[4 - j], i.e. XNOR of the bits.
            assign out[24 - idx] = inputs[4 - i] ~^ inputs[4 - j];
        end
    endgenerate

endmodule