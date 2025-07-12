module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Sum of Products (SOP) form
// Since we're looking at specific minterms for 2, 7, and 15:
// - For 2: ~a & b & ~c & ~d
// - For 7: ~a & b & c & d
// - For 15: a & b & c & d
// So, the SOP expression is:
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product of Sums (POS) form
// Considering the maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14:
// - For 0: ~a & ~b & ~c & ~d
// - For 1: ~a & ~b & ~c & d
// - For 4: ~a & b & ~c & ~d
// - For 5: ~a & b & ~c & d
// - For 6: ~a & b & c & ~d
// - For 9: a & ~b & ~c & d
// - For 10: a & ~b & c & ~d
// - For 13: a & ~b & c & d
// - For 14: a & b & ~c & d
// The POS expression would be the product of these maxterms, but to simplify, let's first express them:
// Note: Since POS directly might be complex due to the number of terms, we'll directly write the expression.
assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) | (a & b & ~c & d) );

endmodule