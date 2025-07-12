module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for outputs=1 at 2,7,15:
    // 2  = ~a & ~b & c & ~d
    // 7,15 = b & c & d
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS from zeros 0,1,4,5,6,9,10,13,14:
    // (a + c + d) & (b + c + ~d) & (~a + ~b + ~c + d)
    assign out_pos = (a | c | d) & (b | c | ~d) & (~a | ~b | ~c | d);

endmodule