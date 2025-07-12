module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
assign out_pos = (a | b | c | d) & (a | ~b | c | d) & (a | b | ~c | d) & (a | b | c | ~d) & 
                 (~a | b | ~c | d) & (~a | b | c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | ~d) & 
                 (~a | ~b | c | ~d) & (~a | b | ~c | ~d) & (~a | ~b | ~c | d);

// However, we can simplify this expression by applying De Morgan's laws and simplifying the resulting expression
// For example, we can observe that the condition for generating a logic-0 can be represented more simply
// The final simplified POS expression is
assign out_pos = (a | b) & (b | c | d);

endmodule