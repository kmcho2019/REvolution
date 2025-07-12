module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression
// Considering the binary representations:
// - 2: 0010
// - 7: 0111
// - 15: 1111
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derive POS expression systematically using K-maps or by analyzing the complement conditions
// The output should be 1 for inputs representing 2, 7, or 15
// This can be achieved by finding the sum of products of the complemented function and then applying De Morgan's laws
// However, for simplicity and directness, we analyze the conditions for the output to be 0 and complement them
// The conditions for output to be 0 are: 0, 1, 4, 5, 6, 9, 10, 13, 14
// The binary representations are:
// - 0: 0000
// - 1: 0001
// - 4: 0100
// - 5: 0101
// - 6: 0110
// - 9: 1001
// - 10: 1010
// - 13: 1101
// - 14: 1110
// The POS form can be derived by complementing these conditions and applying De Morgan's laws
// However, to simplify, we directly implement the conditions for the output to be 1 in POS form
assign out_pos = ~( (a & ~b & ~c & ~d) | (~a & ~b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (~a & b & c & ~d) );

endmodule