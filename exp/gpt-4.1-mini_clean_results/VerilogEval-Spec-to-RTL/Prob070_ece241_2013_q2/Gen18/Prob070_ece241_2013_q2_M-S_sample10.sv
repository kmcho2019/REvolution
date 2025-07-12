module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP for out_sop (1 for 2,7,15):
    // 2  = 0 0 1 0 => ~a & ~b & c & ~d
    // 7  = 0 1 1 1 => ~a & b & c & d
    // 15 = 1 1 1 1 => a & b & c & d
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal POS for out_pos (0 for zeros specified):
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d);
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | ~d);

endmodule