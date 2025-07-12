module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct minterms for 2,7,15
assign out_sop = 
    (~a & ~b &  c & ~d) |  // 2 = 0010
    (~a &  b &  c &  d) |  // 7 = 0111
    ( a &  b &  c &  d);   // 15=1111

// Minimal POS for zeros: 0,1,4,5,6,9,10,13,14
assign out_pos = 
    (a |  b |  c |  d)  & 
    (a | ~b |       d)  & 
    (~a |      c |  d)  & 
    (~a |  b | ~c     );

endmodule