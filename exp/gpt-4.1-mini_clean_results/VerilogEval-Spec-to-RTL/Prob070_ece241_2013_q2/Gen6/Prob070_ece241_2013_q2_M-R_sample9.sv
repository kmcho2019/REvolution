module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP expression for output = 1 for decimal 2,7,15
// 2  = 0 0 1 0 => ~a & ~b &  c & ~d
// 7  = 0 1 1 1 => ~a &  b &  c &  d
// 15 = 1 1 1 1 =>  a &  b &  c &  d
assign out_sop = 
    (~a & ~b &  c & ~d) |
    (~a &  b &  c &  d) |
    ( a &  b &  c &  d);

// Minimal POS expression for output = 0 for decimal 0,1,4,5,6,9,10,13,14:
// out_pos = (a + b + d) & (a + ~b + ~c) & (~a + b + c) & (~a + ~b + c + d)
assign out_pos = 
    (a | b | d) &
    (a | ~b | ~c) &
    (~a | b | c) &
    (~a | ~b | c | d);

endmodule