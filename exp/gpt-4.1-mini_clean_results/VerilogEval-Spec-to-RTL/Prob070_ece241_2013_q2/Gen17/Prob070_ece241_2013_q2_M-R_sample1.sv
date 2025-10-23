module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression:
    // out_sop = a & b & d | b & c & ~d | a & b & c & d
    // Note: The term a b c d is already included in a b d, but keeping for completeness; it can be omitted because a b d covers a b c d.
    // Simplify SOP: out_sop = (a & b & d) | (b & c & ~d)
    assign out_sop = (a & b & d) | (b & c & ~d);

    // Minimal POS expression:
    // out_pos = (a + b + d) & (a + ~b + c) & (~a + b + ~c + ~d)
    assign out_pos = (a | b | d) & (a | ~b | c) & (~a | b | ~c | ~d);

endmodule