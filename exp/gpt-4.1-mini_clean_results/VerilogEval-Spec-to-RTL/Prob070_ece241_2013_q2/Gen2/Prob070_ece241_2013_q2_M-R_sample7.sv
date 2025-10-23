module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for out_sop = Σm(2,7,15)
// 2  = 0 1 0 0  -> !a b !c !d
// 7  = 0 1 1 1  -> !a b c d
// 15 = 1 1 1 1  -> a b c d
assign out_sop = 
    (~a & b & ~c & ~d) | 
    (~a & b & c & d) | 
    (a & b & c & d);

// Minimal POS for out_pos = ΠM(0,1,4,5,6,9,10,13,14)
// Derived minimal form:
// out_pos = (a + b + c + ~d) & (a + ~b + ~c + d) & (~a + ~b + c + d)
assign out_pos = 
    (a | b | c | ~d) & 
    (a | ~b | ~c | d) & 
    (~a | ~b | c | d);

endmodule