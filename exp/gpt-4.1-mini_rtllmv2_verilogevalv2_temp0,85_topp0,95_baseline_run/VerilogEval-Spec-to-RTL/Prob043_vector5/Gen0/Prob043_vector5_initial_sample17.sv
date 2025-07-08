module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a,b,c,d,e};
    genvar i, j;
    wire [24:0] comps;

    generate
        // We map out[24] down to out[0] as per example:
        // order: (a,a), (a,b), (a,c), (a,d), (a,e),
        //        (b,a), (b,b), (b,c), (b,d), (b,e),
        //        (c,a), (c,b), (c,c), (c,d), (c,e),
        //        (d,a), (d,b), (d,c), (d,d), (d,e),
        //        (e,a), (e,b), (e,c), (e,d), (e,e)
        // So out[25*i + j] = inputs[4 - i] XNOR inputs[4 - j] (to match example)
        // But the example shows out[24] = ~a ^ a; which is a XNOR a, so the first comparison is a vs a at out[24].
        // We assign the bits starting from out[24] down to out[0].

        // We'll assign in this order:
        // out[24] = a vs a
        // out[23] = a vs b
        // out[22] = a vs c
        // out[21] = a vs d
        // out[20] = a vs e
        // out[19] = b vs a
        // ...
        // so the index = 24 - (5*i + j) with i,j in [0..4], where i corresponds to first input (a=0, ..., e=4)
        // and j corresponds to second input.

        // inputs vector: inputs[4]=a, inputs[3]=b, inputs[2]=c, inputs[1]=d, inputs[0]=e

        // So we map i and j to inputs indexes as input_i = inputs[4 - i], input_j = inputs[4 - j]

        // We'll build the bits in an array and assign at the end

        for (i=0; i<5; i=i+1) begin : outer
            for (j=0; j<5; j=j+1) begin : inner
                // Calculate bit index
                localparam int bit_index = 24 - (5*i + j);
                assign comps[bit_index] = ~(inputs[4 - i] ^ inputs[4 - j]); // XNOR
            end
        end
    endgenerate

    assign out = comps;

endmodule