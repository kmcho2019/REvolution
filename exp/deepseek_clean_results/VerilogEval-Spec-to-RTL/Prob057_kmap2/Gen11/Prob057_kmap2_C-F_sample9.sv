module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized product terms with clear grouping
wire term1 = ~a & ~b & c & d;           // Essential prime implicant
wire term2 = a & b & (~c | ~d);         // Combined two terms
wire term3 = (b & ~c & d) | (a & c & ~d); // Remaining essential terms

// Combine and invert with clear structure
assign out = ~(term1 | term2 | term3);

endmodule