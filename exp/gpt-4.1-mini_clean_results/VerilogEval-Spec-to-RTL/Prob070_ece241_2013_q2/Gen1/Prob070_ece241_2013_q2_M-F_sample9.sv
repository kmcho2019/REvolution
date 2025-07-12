module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Inputs as 4-bit number: a b c d (a is MSB, d is LSB)

// SOP form: out=1 for decimal 2,7,15
// 2 = 0 0 1 0 -> a'b' c d'
// 7 = 0 1 1 1 and 15=1 1 1 1 combine to b c d (a don't care)
assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

// POS form: zeros at 0,1,4,5,6,9,10,13,14
// Minimal POS from maxterms:
// (a + b + d') (a + b' + c + d) (a' + b + c + d)
assign out_pos = (a | b | ~d) & (a | ~b | c | d) & (~a | b | c | d);

endmodule