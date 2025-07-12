module TopModule (
    input  a,      // Enable control (must be 0)
    input  b,      // High priority input
    input  c,      // Low priority input
    input  d,      // Enable control (must be 0)
    output q       // Conditional OR output
);
    // Functional implementation:
    // Output is (b OR c) only when both a and d are 0
    // Otherwise output is 0
    assign q = (~a & ~d) & (b | c);
endmodule