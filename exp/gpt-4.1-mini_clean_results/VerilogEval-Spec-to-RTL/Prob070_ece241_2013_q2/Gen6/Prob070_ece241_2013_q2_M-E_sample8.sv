module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Inputs form a 4-bit number: {a,b,c,d} with 'a' MSB and 'd' LSB

// Minimal SOP terms for output = 1 for decimal 2(0010),7(0111),15(1111):
// 2: 0 0 1 0 -> ~a & ~b & c & ~d
// 7: 0 1 1 1 -> ~a & b & c & d
// 15:1 1 1 1 -> a & b & c & d
// No further simplification can reduce these minterms.

// Implementing out_sop as minimal sum-of-products:
assign out_sop = 
      (~a & ~b & c & ~d)  // decimal 2
    | (~a &  b & c &  d)  // decimal 7
    | ( a &  b & c &  d); // decimal 15

// Minimal POS can be obtained by applying De Morgan to SOP:
// F = m2 + m7 + m15
// So F' = Product of maxterms covering zeros

// Alternatively, the minimal POS from problem analysis:
// out_pos = (a + b + d) & (a + ~b + ~c) & (~a + b + c) & (~a + ~b + c + d)

assign out_pos = 
    (a | b | d) &
    (a | ~b | ~c) &
    (~a | b | c) &
    (~a | ~b | c | d);

endmodule