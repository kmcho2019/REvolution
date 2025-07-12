module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP form for outputs 1 at decimal 2,7,15
// Decimal 2  = 0 0 1 0 => ~a & ~b & c & ~d
// Decimal 7  = 0 1 1 1 => ~a & b & c & d
// Decimal 15 = 1 1 1 1 => a & b & c & d
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimal POS form derived from Karnaugh map for zeros at 0,1,4,5,6,9,10,13,14
// out_pos = (a + b + d) & (a + ~b + d) & (a + b + ~c) & (~a + b + ~d) & (~a + ~b + ~c)
wire term1 = a | b | d;
wire term2 = a | (~b) | d;
wire term3 = a | b | (~c);
wire term4 = (~a) | b | (~d);
wire term5 = (~a) | (~b) | (~c);

assign out_pos = term1 & term2 & term3 & term4 & term5;

endmodule