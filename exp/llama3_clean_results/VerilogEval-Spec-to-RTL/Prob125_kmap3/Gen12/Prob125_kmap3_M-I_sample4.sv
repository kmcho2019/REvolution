module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The original expression is already simplified and efficient.
// However, to explore potential optimizations, we could consider
// alternative expressions that capture the same logic but might
// be synthesized differently.

// Original expression
assign out = a | (~a & ~b & c);

// Alternative expression to potentially optimize synthesis
// assign out = (a | c) & (~b | a);

// After analysis, the original expression seems to be the most straightforward
// and efficient way to implement the logic. Thus, we stick with it.

endmodule