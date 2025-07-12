module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for out_sop = 1 at 2,7,15
assign out_sop = (~a & ~b &  c & ~d) |  // 2
                 (~a &  b &  c &  d) |  // 7
                 ( a &  b &  c &  d);   // 15

// Minimal POS for out_pos (0 at 0,1,4,5,6,9,10,13,14)
assign out_pos = (a | b | ~c | d) &    // covers 0,1,4,5,6 zero minterms
                 (a | ~b | ~c | ~d) &  // covers 0,1,9,10 zero minterms
                 (~a | ~b | ~c | d);   // covers 0,1,4,9 zero minterms

endmodule