module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // 'd' is don't-care, not used in the logic
    output out
);

// Refactored version maintaining the same logic but ensuring clarity
// The original expression is already optimized, so we focus on readability
assign out = (a) ? 1'b1 : ((~b) && c);

endmodule