module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for outputs 2,7,15 with don't cares 3,8,11,12:
    // out_sop = (b & c & d) | (~a & ~b & c & ~d)
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS expression derived from zeros and don't cares:
    // out_pos = (a + b + ~c + ~d) & (~a + b + ~c + d) & (a + ~b + ~c + d)
    assign out_pos = (a | b | ~c | ~d) & (~a | b | ~c | d) & (a | ~b | ~c | d);

endmodule