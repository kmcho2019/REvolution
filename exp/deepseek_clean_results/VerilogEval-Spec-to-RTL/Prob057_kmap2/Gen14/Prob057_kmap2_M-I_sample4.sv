module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized implementation using NAND-NAND logic and shared sub-expressions
wire term1 = ~(a & b & ~c & ~d);      // Essential for cd=00,ab=11
wire term2 = ~(~a & ~b & c & d);      // Essential for cd=11,ab=00
wire term3 = ~(b & ~c & d);           // Covers two cd=01 cases
wire term4 = ~(a & c & ~d);           // Covers two cd=10 cases

assign out = ~(term1 & term2 & term3 & term4);

endmodule