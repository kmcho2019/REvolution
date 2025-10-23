module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP with don't-cares considered:
    // out_sop = (c & d) | (~a & b & c) | (~a & ~b & c & ~d)
    assign out_sop = (c & d) | (~a & b & c) | (~a & ~b & c & ~d);

    // Minimal POS derived from zeros and don't-cares:
    // out_pos = (a + c + d) & (b + c + ~d)
    assign out_pos = (a | c | d) & (b | c | ~d);

endmodule