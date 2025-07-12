module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate product terms
wire term1 = ~a & ~b & c & d;  // Essential for cd=11,ab=00
wire term2 = b & ~c & d;       // Covers two cd=01 cases
wire term3 = a & c & ~d;       // Covers two cd=10 cases
wire term4 = a & b & ~c & ~d;  // Essential for cd=00,ab=11

// Final OR combination with inversion
assign out = ~(term1 | term2 | term3 | term4);

endmodule