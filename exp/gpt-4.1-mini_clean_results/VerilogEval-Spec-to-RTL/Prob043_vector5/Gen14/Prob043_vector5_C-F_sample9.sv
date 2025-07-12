module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexing convenience
    wire [4:0] inputs = {a, b, c, d, e};

    // Assign all 25 pairwise comparisons in specified bit order:
    // out[24] = a ~^ a, out[23] = a ~^ b, ..., out[0] = e ~^ e
    assign out = {
        inputs[4] ~^ inputs[4], // out[24] = a ~^ a
        inputs[4] ~^ inputs[3], // out[23] = a ~^ b
        inputs[4] ~^ inputs[2], // out[22] = a ~^ c
        inputs[4] ~^ inputs[1], // out[21] = a ~^ d
        inputs[4] ~^ inputs[0], // out[20] = a ~^ e

        inputs[3] ~^ inputs[4], // out[19] = b ~^ a
        inputs[3] ~^ inputs[3], // out[18] = b ~^ b
        inputs[3] ~^ inputs[2], // out[17] = b ~^ c
        inputs[3] ~^ inputs[1], // out[16] = b ~^ d
        inputs[3] ~^ inputs[0], // out[15] = b ~^ e

        inputs[2] ~^ inputs[4], // out[14] = c ~^ a
        inputs[2] ~^ inputs[3], // out[13] = c ~^ b
        inputs[2] ~^ inputs[2], // out[12] = c ~^ c
        inputs[2] ~^ inputs[1], // out[11] = c ~^ d
        inputs[2] ~^ inputs[0], // out[10] = c ~^ e

        inputs[1] ~^ inputs[4], // out[9]  = d ~^ a
        inputs[1] ~^ inputs[3], // out[8]  = d ~^ b
        inputs[1] ~^ inputs[2], // out[7]  = d ~^ c
        inputs[1] ~^ inputs[1], // out[6]  = d ~^ d
        inputs[1] ~^ inputs[0], // out[5]  = d ~^ e

        inputs[0] ~^ inputs[4], // out[4]  = e ~^ a
        inputs[0] ~^ inputs[3], // out[3]  = e ~^ b
        inputs[0] ~^ inputs[2], // out[2]  = e ~^ c
        inputs[0] ~^ inputs[1], // out[1]  = e ~^ d
        inputs[0] ~^ inputs[0]  // out[0]  = e ~^ e
    };
endmodule