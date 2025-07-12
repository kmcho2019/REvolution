module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
// Since we need to implement the product of sums, let's first find the sum of the maxterms
// corresponding to the conditions for logic-0, then complement the result.
// The maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14 are:
// ~a & ~b & ~c & ~d, ~a & ~b & ~c & d, ~a & ~b & c & ~d, ~a & ~b & c & d, 
// ~a & ~b & ~c & d, ~a & b & ~c & d, ~a & b & c & ~d, ~a & b & c & d, 
// a & ~b & ~c & ~d, a & ~b & ~c & d, a & ~b & c & ~d, a & b & ~c & ~d, 
// a & b & ~c & d, a & b & c & ~d
// However, since the out_pos is the product of sums, and given the specific conditions,
// we can find the POS form by considering the logic-0 conditions and simplifying them.
// Given the input conditions, we directly implement the POS based on the logic-0 conditions.
assign out_pos = ~( (~a | ~b | ~c | ~d) & (~a | ~b | c | ~d) & (~a | b | ~c | ~d) & 
                  (~a | b | ~c | d) & (~a | b | c | ~d) & (a | ~b | ~c | ~d) & 
                  (a | ~b | ~c | d) & (a | ~b | c | ~d) & (a | b | ~c | ~d));

endmodule