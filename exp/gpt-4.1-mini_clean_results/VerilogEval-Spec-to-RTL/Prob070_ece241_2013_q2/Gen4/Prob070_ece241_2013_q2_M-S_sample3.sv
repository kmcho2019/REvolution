module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for outputs 1 at decimal 2,7,15
assign out_sop = (~a & ~b &  c & ~d)  // 2:  0010
               | (~a &  b &  c &  d)  // 7:  0111
               | ( a &  b &  c &  d); // 15: 1111

// Minimal POS form derived by boolean simplification:
// out_pos = c & (b + a) & (b + ~a)
assign out_pos = c & (b | a) & (b | ~a);

endmodule