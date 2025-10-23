module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best of both examples
assign out = ~(
    (!a & ((!b & c & d) | (b & !c & d))) |  // Combines cd=11 ab=00 and cd=01 ab=01
    (a & ((b & !c) | (c & !d)))             // Combines cd=01,00 ab=11 and cd=10 ab=11,10
);

endmodule