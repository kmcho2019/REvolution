module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best terms from both examples
assign out = ~(
    (!a & !b & c & d) |  // Covers cd=11, ab=00
    (!c & d & b) |       // Covers cd=01 cases where b=1
    (c & !d & a) |       // Covers cd=10 cases where a=1
    (a & b & !c & !d)    // Covers cd=00, ab=11
);

endmodule