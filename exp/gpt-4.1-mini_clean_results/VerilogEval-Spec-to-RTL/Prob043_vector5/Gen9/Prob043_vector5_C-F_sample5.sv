module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] comp_bits;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Each output bit corresponds to comparison of inputs[i], inputs[j]
                // Bit index: 24 - (5*i + j)
                assign comp_bits[24 - (5*i + j)] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

    // Assign the computed bits to the output directly
    assign out = comp_bits;

endmodule