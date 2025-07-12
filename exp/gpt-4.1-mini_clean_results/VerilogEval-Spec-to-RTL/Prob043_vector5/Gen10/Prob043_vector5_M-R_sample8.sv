module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] comp_bits;

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_comp
            // Calculate i and j from idx
            // idx = 5*i + j
            // i = idx / 5, j = idx % 5
            wire [2:0] i = idx / 5;
            wire [2:0] j = idx % 5;
            assign comp_bits[24 - idx] = inputs[4 - i] ~^ inputs[4 - j];
        end
    endgenerate

    assign out = comp_bits;

endmodule