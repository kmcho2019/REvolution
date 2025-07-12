module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for common patterns
wire ab00 = ~a & ~b;
wire ab11 = a & b;
wire cd00 = ~c & ~d;
wire cd10 = c & ~d;

// Optimized Boolean expression with just 3 terms
assign out = (ab00) |               // Covers ab=00 for cd=00,01,10
             (ab11 & (cd00 | cd10)) | // Covers ab=11 for cd=00,10
             (~a & b & ~c & d);      // Covers ab=01 cd=01

endmodule