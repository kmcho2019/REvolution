module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best aspects of both examples
assign out = ~(
    (c & d & ~a & ~b) |  // cd=11, ab=00
    (~c & d & b) |       // cd=01, b=1 (combines two cases)
    (c & ~d & a) |       // cd=10, a=1 (combines two cases)
    (~c & ~d & a & b)    // cd=00, ab=11
);

endmodule