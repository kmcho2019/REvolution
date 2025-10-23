module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for outputs 2,7,15:
// 2  =  0 0 1 0  => ~a & ~b & c & ~d
// 7  =  0 1 1 1  => ~a &  b & c &  d
// 15 =  1 1 1 1  =>  a &  b & c &  d
assign out_sop = 
      (~a & ~b &  c & ~d)
    | (~a &  b &  c &  d)
    | ( a &  b &  c &  d);

// Minimal POS for the same function (covering zero outputs):
// Zeros: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
// POS derived from maxterms covering these zeros with don't cares on 3,8,11,12:
// (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
assign out_pos = 
      (a  | b  | ~c | d)
    & (a  | ~b |  c | d)
    & (~a | b  |  c | d);

endmodule