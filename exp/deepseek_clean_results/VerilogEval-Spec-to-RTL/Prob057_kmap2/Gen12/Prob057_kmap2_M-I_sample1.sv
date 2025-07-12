module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire c_n, d_n;
wire term1, term2, term3, term4, term5;

// Common subexpressions
assign c_n = ~c;
assign d_n = ~d;

// Factored terms
assign term1 = (c_n & d_n) & (~a | b);  // Covers cd=00 cases
assign term2 = (c_n & d) & (~a | a);    // Covers cd=01 cases (simplifies to c_n & d)
assign term3 = (c & d_n) & (b | a);     // Covers cd=10 cases
assign term4 = (c & d) & (~a | b | a);  // Covers cd=11 cases (simplifies to c & d)

assign out = term1 | term2 | term3 | term4;

endmodule