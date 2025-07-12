module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Essential prime implicant
wire term1 = ~a & ~b & c & d;

// Combined terms for a & b cases
wire term2 = a & b & (~c | ~d);

// Shared literal terms
wire term3 = (b & ~c & d) | (a & c & ~d);

// Final NOR operation
assign out = ~(term1 | term2 | term3);

endmodule