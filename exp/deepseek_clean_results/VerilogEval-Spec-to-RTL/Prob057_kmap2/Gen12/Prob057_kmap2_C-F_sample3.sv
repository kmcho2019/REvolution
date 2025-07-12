module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best of both solutions
assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00
    (!c & d & b) |       // cd=01, simplified
    (c & !d & a) |       // cd=10, simplified
    (a & b & !c & !d)    // cd=00, ab=11
);

endmodule