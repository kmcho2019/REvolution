module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP from K-map covering minterms 2,7,15 with don't-cares at 3,8,11,12:
    // out_sop = (~a & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    assign out_sop = (~a & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal POS from K-map for same minterms:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | d);

endmodule