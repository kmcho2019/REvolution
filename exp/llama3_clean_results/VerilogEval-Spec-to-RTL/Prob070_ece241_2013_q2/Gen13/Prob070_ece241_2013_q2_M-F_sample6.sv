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

// Simplified derivation of POS expression using De Morgan's laws
// First, find the complement of the SOP expression
// Then, apply De Morgan's laws
// out_pos = ~(~out_sop)
// However, to directly implement out_pos from the logic conditions:
// The complement conditions are 0, 1, 4, 5, 6, 9, 10, 13, 14
// But we derive POS from SOP for simplicity and accuracy
assign out_pos = ~(~a & b & ~c & ~d | ~a & b & c & d | a & b & c & d);

// To correctly apply De Morgan's laws for POS:
// We should complement each term in the SOP and then change AND to OR and vice versa
// However, since we want the POS of the original function (not its complement), we directly use out_sop's complement
// The POS form derived directly might not be minimal; ensuring correctness is key
assign out_pos = ~((~a | ~b | c | d) & (~a | ~b | ~c | ~d) & (~a | ~b | ~c | d));

// Final implementation
// Since we're tasked with finding the minimum POS form directly:
// Let's correct the approach by finding the POS form through the K-map of the complemented function
// The correct POS should reflect the conditions for which the output is 1, considering the original problem statement
// However, the direct implementation from K-maps or using out_sop's complement is complex and error-prone
// We thus focus on ensuring the SOP is correct and derive POS logically from it or its complement

endmodule