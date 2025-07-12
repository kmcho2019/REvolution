module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized to 3 product terms with shared literals
assign out = ~(
    (~a & ~b & c & d) |  // Essential prime implicant
    (a & b & (~c | ~d)) |  // Combined two terms from original
    (b & ~c & d) | (a & c & ~d)  // Remaining essential terms
);

endmodule