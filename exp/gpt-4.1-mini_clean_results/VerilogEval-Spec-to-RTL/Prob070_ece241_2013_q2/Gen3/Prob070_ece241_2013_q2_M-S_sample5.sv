module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP: output 1 for decimal 2, 7, 15
assign out_sop = (~a & ~b & c & ~d)  // decimal 2: 0 0 1 0
               | (~a &  b & c &  d)  // decimal 7: 0 1 1 1
               | ( a &  b & c &  d); // decimal 15:1 1 1 1

// Minimal POS: complement of SOP expressed as product of maxterms (~m2 & ~m7 & ~m15)
assign out_pos = (a | b | ~c | d)
               & (a | ~b | ~c | ~d)
               & (~a | ~b | ~c | ~d);

endmodule