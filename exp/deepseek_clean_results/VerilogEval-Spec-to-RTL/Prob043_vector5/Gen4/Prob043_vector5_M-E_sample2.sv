module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Systematic generation of all pairwise comparisons
    // Organized as 5 rows (a-e) x 5 columns (a-e)
    assign out[24:20] = {
        ~(a ^ a),  // a vs a
        ~(a ^ b),  // a vs b
        ~(a ^ c),  // a vs c
        ~(a ^ d),  // a vs d
        ~(a ^ e)   // a vs e
    };

    assign out[19:15] = {
        ~(b ^ a),  // b vs a
        ~(b ^ b),  // b vs b
        ~(b ^ c),  // b vs c
        ~(b ^ d),  // b vs d
        ~(b ^ e)   // b vs e
    };

    assign out[14:10] = {
        ~(c ^ a),  // c vs a
        ~(c ^ b),  // c vs b
        ~(c ^ c),  // c vs c
        ~(c ^ d),  // c vs d
        ~(c ^ e)   // c vs e
    };

    assign out[9:5] = {
        ~(d ^ a),  // d vs a
        ~(d ^ b),  // d vs b
        ~(d ^ c),  // d vs c
        ~(d ^ d),  // d vs d
        ~(d ^ e)   // d vs e
    };

    assign out[4:0] = {
        ~(e ^ a),  // e vs a
        ~(e ^ b),  // e vs b
        ~(e ^ c),  // e vs c
        ~(e ^ d),  // e vs d
        ~(e ^ e)   // e vs e
    };

endmodule