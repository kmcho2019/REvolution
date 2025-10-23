module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized terms based on K-map analysis
wire term1 = ~a & ~b & ~d;      // Covers 00/00 and 00/01
wire term2 = b & (~c | ~d);     // Covers 01/11 and 11/11
wire term3 = a & c & ~d;        // Covers 11/01

// Final output as OR of all terms
assign out = term1 | term2 | term3;

endmodule