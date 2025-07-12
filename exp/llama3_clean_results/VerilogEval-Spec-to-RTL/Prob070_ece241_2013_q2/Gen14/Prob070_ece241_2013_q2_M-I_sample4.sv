module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Derive the SOP expression using the correct binary representations
// 2: 0010
// 7: 0111
// 15: 1111
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derive the POS expression by considering all possible input combinations
// and applying Boolean algebra principles
assign out_pos = ~((a & ~b) | (~a & ~b & ~c) | (~a & ~b & ~d) | (~a & ~c & ~d) | (a & ~b & ~c) | (a & ~b & ~d) | (~b & ~c & ~d));

// Note: The POS expression is derived based on the principle of including
// all conditions that lead to an output of 0 (complement of the given conditions)
// and then applying De Morgan's laws and simplification.

endmodule