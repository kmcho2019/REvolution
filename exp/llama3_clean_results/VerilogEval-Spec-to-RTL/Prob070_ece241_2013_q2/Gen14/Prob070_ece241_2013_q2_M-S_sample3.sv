module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derivation of POS expression
// Since the problem specifies certain inputs never occur, we focus on the conditions given
// For POS, consider the complement of the conditions for 0, and apply De Morgan's laws
// However, for simplicity and accuracy, we'll derive POS directly from the logic conditions
// The conditions for 0 are 0, 1, 4, 5, 6, 9, 10, 13, 14, which we'll complement
// The correct POS should reflect the conditions for which the output is 1
assign out_pos = ~( (~a & ~b) | (~a & c & ~d) | (~a & ~c & d) | (a & ~b) | (~c & ~d) );

endmodule