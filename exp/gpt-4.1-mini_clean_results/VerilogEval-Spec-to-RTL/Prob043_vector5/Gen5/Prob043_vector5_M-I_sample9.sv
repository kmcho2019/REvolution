module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Define inputs in natural order: index 0->a, 1->b, ..., 4->e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_pairs
            // Compute i,j pair indices from idx (row major)
            // i = idx / 5, j = idx % 5
            // According to original spec, out[24] = ~(a^a), so mapping must invert indexing:
            // Map bits so out[24 - idx] corresponds to inputs[i], inputs[j]
            // That is, bit = 24 - idx = (4 - i)*5 + (4 - j)
            // Solve for i and j:
            // i = idx / 5; j = idx % 5
            // actual bit index = 24 - idx = (4 - i)*5 + (4 - j)
            // So output indexing goes as out[24 - idx] = XNOR(inputs[i], inputs[j])
            // To assign output bits in ascending order [0..24], assign out[24 - idx]

            wire [2:0] i = idx / 5;
            wire [2:0] j = idx % 5;
            assign out[24 - idx] = inputs[i] ~^ inputs[j]; // XNOR operator directly
        end
    endgenerate
endmodule