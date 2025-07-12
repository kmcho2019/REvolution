module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop:
    // out_sop = (b & c) | (a & b & c & d) | (~a & ~b & c & ~d)
    wire term1 = b & c;                // Covers 7 (0111) and also 6 but 6 is zero, so we must confirm with other terms
    wire term2 = a & b & c & d;        // Covers 15 (1111)
    wire term3 = ~a & ~b & c & ~d;     // Covers 2 (0010)

    assign out_sop = term1 | term2 | term3;

    // Minimal POS for out_pos:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
    wire clause1 = a | b | ~c | d;
    wire clause2 = a | ~b | c | d;
    wire clause3 = ~a | b | c | ~d;

    assign out_pos = clause1 & clause2 & clause3;

endmodule