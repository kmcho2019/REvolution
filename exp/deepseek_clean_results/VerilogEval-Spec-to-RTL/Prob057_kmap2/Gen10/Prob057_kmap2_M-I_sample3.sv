module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized product terms
wire term1 = !a & !b;      // Covers cd=00,01,10 for ab=00
wire term2 = a & b;        // Covers cd=00,11 for ab=11
wire term3 = !c & d;       // Covers ab=01,11 for cd=01
wire term4 = c & !d;       // Covers ab=11 for cd=10

// Combine terms (no inversion needed as we're implementing the 0 cases)
assign out = ~(term1 | term2 | term3 | term4);

endmodule