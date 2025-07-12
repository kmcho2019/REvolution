module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP from minterms {2,7,15} and don't-cares {3,8,11,12}:
    // out_sop = (~a & ~b & c) | (b & c & d)
    assign out_sop = (~a & ~b & c) | (b & c & d);

    // Minimal POS from zeros {0,1,4,5,6,9,10,13,14} with don't-cares:
    // out_pos = (a + b + ~c + d) & (~a + b + c + ~d) & (a + ~b + c + ~d)
    assign out_pos = (a | b | ~c | d) & (~a | b | c | ~d) & (a | ~b | c | ~d);

endmodule