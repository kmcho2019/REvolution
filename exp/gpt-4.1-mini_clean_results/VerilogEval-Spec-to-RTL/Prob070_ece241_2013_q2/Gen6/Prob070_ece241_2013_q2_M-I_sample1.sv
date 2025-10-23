module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Corrected minimal SOP:
    // out_sop = (~a & ~b & c) | (c & d)
    assign out_sop = (~a & ~b & c) | (c & d);

    // Corrected minimal POS:
    // out_pos = (a + b + ~c + d) & (a + ~b + ~c + ~d) & (~a + b + c + ~d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d) & (~a | b | c | ~d);

endmodule