module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP derived from K-map with don't-cares:
    // out_sop = (~a & b & c) + (a & b & c & d)
    assign out_sop = (~a & b & c) | (a & b & c & d);

    // Minimal POS derived:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + ~d) & (~a + ~b + ~c + d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | ~d) & (~a | ~b | ~c | d);

endmodule