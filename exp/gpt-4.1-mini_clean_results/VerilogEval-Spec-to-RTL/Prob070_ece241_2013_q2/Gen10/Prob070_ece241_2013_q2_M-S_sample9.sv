module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP: sum of minterms for 2,7,15
    assign out_sop = (~a & ~b & c & ~d) |
                     (~a &  b & c &  d) |
                     ( a &  b & c &  d);

    // Minimal POS from zero-set and don't-cares
    assign out_pos = (a | b | ~d) & (a | ~c | d) & (~a | ~b | c);

endmodule