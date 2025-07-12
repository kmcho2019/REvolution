module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP expression:
// For outputs 2(0010),7(0111),15(1111)
// - 2 = ~a & ~b & c & ~d
// - 7 and 15 share b & c & d
// Thus:
// out_sop = (~a & ~b & c & ~d) | (b & c & d)
assign out_sop = 
      (~a & ~b &  c & ~d)
    | ( b &  c &  d);

// Minimal POS expression:
// Zeros at 0,1,4,5,6,9,10,13,14; don't cares at 3,8,11,12
// Derived minimal POS:
// (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
assign out_pos = 
      (a  | b  | ~c | d)
    & (a  | ~b |  c | d)
    & (~a | b  |  c | ~d);

endmodule