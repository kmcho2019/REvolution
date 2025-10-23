module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for function = 1 at inputs 2,7,15:
    // out_sop = (~a & ~b & c) | (c & d)
    assign out_sop = (~a & ~b & c) | (c & d);

    // Minimal POS for function (complement of SOP):
    // out_pos = (a + b + ~c) & (~c + ~d)
    // Covers all zeros (0,1,4,5,6,9,10,13,14) and don't-cares.
    assign out_pos = (a | b | ~c) & (~c | ~d);

endmodule