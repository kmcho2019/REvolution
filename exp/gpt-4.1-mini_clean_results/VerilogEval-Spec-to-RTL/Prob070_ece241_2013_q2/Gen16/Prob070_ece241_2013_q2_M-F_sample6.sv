module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP with don't-cares included:
    // out_sop = (c & d) + (a & b & c) + (~a & ~b & c & ~d)
    assign out_sop = (c & d) | (a & b & c) | (~a & ~b & c & ~d);

    // Minimal POS with don't-cares included:
    // out_pos = (a + b + c) & (b + ~c + d)
    assign out_pos = (a | b | c) & (b | ~c | d);

endmodule