module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for f=1 at decimal 2,7,15:
    // f = (c & d) | (~a & ~b & c & ~d)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Minimal POS expression for f=1 covering zeros:
    // f = (a + b + ~c + d) & (a + ~b + ~c + ~d) & (~a + b + c + d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d) & (~a | b | c | d);

endmodule