module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP covering 2,7,15 with given don't-cares
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS covering zeros 0,1,4,5,6,9,10,13,14
    assign out_pos = (a | b | ~c | ~d) & (a | ~b | ~c | d) & (~a | b | c | d);

endmodule