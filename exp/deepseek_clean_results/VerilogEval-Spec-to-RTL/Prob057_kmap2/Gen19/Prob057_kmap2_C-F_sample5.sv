module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best of both examples
assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00
    (a & b & !c) |       // Combined cd=00,01 ab=11
    (a & c & !d) |       // Combined cd=10 ab=11,10
    (!a & b & !c & d)    // cd=01 ab=01
);

endmodule