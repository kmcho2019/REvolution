module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop: a'b'c d' + b c d
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimal POS for out_pos: (a + c)(b' + d)(a' + b + d')
    assign out_pos = (a | c) & (~b | d) & (~a | b | ~d);

endmodule