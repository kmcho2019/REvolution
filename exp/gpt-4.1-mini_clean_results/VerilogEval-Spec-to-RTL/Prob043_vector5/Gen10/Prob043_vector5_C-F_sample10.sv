module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Inputs vector in natural order: inputs[0]=a ... inputs[4]=e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : gen_pairs
            // Map k (0..24) to pair indices (i,j) with i,j in [0..4]
            // According to problem, bits are ordered:
            // out[24] = ~(a^a) corresponds to (i=0,j=0)
            // out[23] = ~(a^b) corresponds to (i=0,j=1)
            // ...
            // out[0]  = ~(e^e) corresponds to (i=4,j=4)
            //
            // So bit index = 24 - (i*5 + j) where i and j are indices into inputs.
            // Or equivalently, i = k / 5, j = k % 5, and out[24 - k] = inputs[i] ^~ inputs[j]
            //
            // Therefore:
            // out[24 - k] = inputs[i] ^~ inputs[j]
            wire [2:0] i = k / 5;
            wire [2:0] j = k % 5;

            assign out[24 - k] = inputs[i] ^~ inputs[j];
        end
    endgenerate

endmodule