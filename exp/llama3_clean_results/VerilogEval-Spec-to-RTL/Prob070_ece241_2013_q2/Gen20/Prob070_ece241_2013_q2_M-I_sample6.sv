module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the minterms for SOP
wire minterm_2 = ~a & b & ~c & ~d; // 0010
wire minterm_7 = ~a & b & c & d;   // 0111
wire minterm_15 = a & b & c & d;    // 1111

// Define the SOP expression
assign out_sop = minterm_2 | minterm_7 | minterm_15;

// Define the maxterms for POS
// For a product-of-sums expression, we need to consider the complement of the minterms
// of the undesired conditions. However, since we are directly given the desired conditions,
// we will derive the POS expression based on the complement of the undesired conditions.
// The undesired conditions are 0, 1, 4, 5, 6, 9, 10, 13, 14.
// To simplify, we look for patterns or use a Karnaugh map to minimize the expression.

// Given the complexity and the need for precise implementation, let's reconsider the POS expression.
// We aim for a minimized product-of-sums form that correctly represents the desired output.
// The POS expression should be the product of sum terms, where each sum term is a combination
// of literals (a, b, c, d or their complements) that covers the undesired conditions.

// A correct approach to derive the POS expression would involve:
// 1. Identifying the maxterms for the undesired conditions (0, 1, 4, 5, 6, 9, 10, 13, 14).
// 2. Simplifying these maxterms into a product-of-sums form.

// However, given the direct implementation of SOP and the complexity of manually deriving
// a minimized POS expression without visual aids like Karnaugh maps, the focus should be
// on ensuring the SOP expression is correct and recognizing that the POS expression given
// might not be the most optimized form.

// For optimization and clarity, consider using a tool or method to minimize the logic.
// The current implementation prioritizes direct expression of the given conditions over
// complex manual minimization of the POS expression.

// To directly implement the POS based on the given conditions without manual minimization:
assign out_pos = (a | ~b | ~c | ~d) & (~a | ~b | ~c | d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) &
                 (~a | b | c | ~d) & (a | ~b | ~c | d) & (a | ~b | c | ~d) & (a | b | ~c | d) &
                 (a | b | c | ~d);

endmodule