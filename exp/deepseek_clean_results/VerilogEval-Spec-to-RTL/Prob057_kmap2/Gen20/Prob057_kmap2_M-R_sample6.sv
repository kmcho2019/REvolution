module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Break down into intermediate terms
wire term1 = !a & !b & c & d;  // cd=11, ab=00
wire term2 = a & b & !c;       // Combined: cd=01,11 ab=11 and cd=00 ab=11
wire term3 = a & c & !d;       // Combined: cd=10 ab=11 and cd=10 ab=10
wire term4 = !a & b & !c & d;  // cd=01 ab=01

// Combine terms and invert
assign out = ~(term1 | term2 | term3 | term4);

endmodule