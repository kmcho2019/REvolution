module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Systematic pairwise comparisons using XNOR
    // Grouped by first operand for better readability and potential optimization
    assign out[24:20] = {
        ~(a ^ a),  // a == a (will optimize to 1'b1)
        ~(a ^ b),
        ~(a ^ c),
        ~(a ^ d),
        ~(a ^ e)
    };

    assign out[19:15] = {
        ~(b ^ a),  // b == a (same as a == b)
        ~(b ^ b),  // b == b
        ~(b ^ c),
        ~(b ^ d),
        ~(b ^ e)
    };

    assign out[14:10] = {
        ~(c ^ a),  // c == a
        ~(c ^ b),  // c == b
        ~(c ^ c),  // c == c
        ~(c ^ d),
        ~(c ^ e)
    };

    assign out[9:5] = {
        ~(d ^ a),  // d == a
        ~(d ^ b),  // d == b
        ~(d ^ c),  // d == c
        ~(d ^ d),  // d == d
        ~(d ^ e)
    };

    assign out[4:0] = {
        ~(e ^ a),  // e == a
        ~(e ^ b),  // e == b
        ~(e ^ c),  // e == c
        ~(e ^ d),  // e == d
        ~(e ^ e)   // e == e
    };

endmodule