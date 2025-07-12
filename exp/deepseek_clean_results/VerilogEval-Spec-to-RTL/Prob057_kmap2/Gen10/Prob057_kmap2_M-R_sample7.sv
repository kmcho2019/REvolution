module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate wires for common sub-expressions
wire term1 = ~a & ~b & c & d;       // First essential prime implicant
wire term2 = a & b & (~c | ~d);     // Combined two terms
wire term3 = b & ~c & d;            // Third essential term
wire term4 = a & c & ~d;            // Fourth essential term

// Final output as NOR of all terms
assign out = ~(term1 | term2 | term3 | term4);

endmodule