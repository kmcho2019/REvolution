module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// out_sop minimal sum of products form
// out_sop = a' b' c d' + b c d
assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

// For out_pos minimal product of sums form
// The zeros are for input combinations: 0,1,4,5,6,9,10,13,14
// Corresponding maxterms for zeros:
// 0  = 0000 => (a + b + c + d)
// 1  = 0001 => (a + b + c + ~d)
// 4  = 0100 => (a + ~b + c + d)
// 5  = 0101 => (a + ~b + c + ~d)
// 6  = 0110 => (a + ~b + ~c + d)
// 9  = 1001 => (~a + b + c + ~d)
// 10 = 1010 => (~a + b + ~c + d)
// 13 = 1101 => (~a + ~b + c + ~d)
// 14 = 1110 => (~a + ~b + ~c + d)

// We simplify to minimal POS using these maxterms:
// A minimal expression derived (manual K-map simplification) is:
// out_pos = (a + b + c' + d) & (a + b' + c + d') & (a' + b + c + d) & (a' + b' + c' + d')

wire term1 = a | b | (~c) | d;
wire term2 = a | (~b) | c | (~d);
wire term3 = (~a) | b | c | d;
wire term4 = (~a) | (~b) | (~c) | d;

assign out_pos = term1 & term2 & term3 & term4;

endmodule