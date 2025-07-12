module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized terms combining best of both solutions
wire term1 = ~a & ~b & c & d;    // cd=11, ab=00
wire term2 = a & b & (~c | ~d);  // Combines cd=11,ab=01 and cd=00,ab=11
wire term3 = b & ~c & d;         // cd=01 cases
wire term4 = a & c & ~d;         // cd=10 cases

// Final NOR implementation
assign out = ~(term1 | term2 | term3 | term4);

endmodule