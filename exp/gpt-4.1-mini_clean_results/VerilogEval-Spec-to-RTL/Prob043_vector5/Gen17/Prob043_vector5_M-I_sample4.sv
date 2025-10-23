module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs: inputs[4] = a down to inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Assign all 25 pairwise comparisons in specified order:
    // out[24] = a~^a, out[23] = a~^b, ..., out[0] = e~^e
    assign out = {
        ~(inputs[4] ^ inputs[4]), // a vs a
        ~(inputs[4] ^ inputs[3]), // a vs b
        ~(inputs[4] ^ inputs[2]), // a vs c
        ~(inputs[4] ^ inputs[1]), // a vs d
        ~(inputs[4] ^ inputs[0]), // a vs e

        ~(inputs[3] ^ inputs[4]), // b vs a
        ~(inputs[3] ^ inputs[3]), // b vs b
        ~(inputs[3] ^ inputs[2]), // b vs c
        ~(inputs[3] ^ inputs[1]), // b vs d
        ~(inputs[3] ^ inputs[0]), // b vs e

        ~(inputs[2] ^ inputs[4]), // c vs a
        ~(inputs[2] ^ inputs[3]), // c vs b
        ~(inputs[2] ^ inputs[2]), // c vs c
        ~(inputs[2] ^ inputs[1]), // c vs d
        ~(inputs[2] ^ inputs[0]), // c vs e

        ~(inputs[1] ^ inputs[4]), // d vs a
        ~(inputs[1] ^ inputs[3]), // d vs b
        ~(inputs[1] ^ inputs[2]), // d vs c
        ~(inputs[1] ^ inputs[1]), // d vs d
        ~(inputs[1] ^ inputs[0]), // d vs e

        ~(inputs[0] ^ inputs[4]), // e vs a
        ~(inputs[0] ^ inputs[3]), // e vs b
        ~(inputs[0] ^ inputs[2]), // e vs c
        ~(inputs[0] ^ inputs[1]), // e vs d
        ~(inputs[0] ^ inputs[0])  // e vs e
    };

endmodule