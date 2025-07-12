module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Correct minimal SOP for minterms 2(0010),7(0111),15(1111):
    // out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal POS covering zeros with don't cares at 3,8,11,12:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | d);

endmodule