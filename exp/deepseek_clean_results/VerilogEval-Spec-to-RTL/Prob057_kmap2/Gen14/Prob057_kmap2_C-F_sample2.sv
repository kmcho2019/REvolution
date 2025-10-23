module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized fusion of both examples
assign out = ~(
    (!a & !b & c & d) |    // Essential term 1
    (a & b & (!c | !d)) |  // Combined a&b terms
    (!c & d & (a ^ b)) |   // XOR optimization
    (c & !d & a)           // Remaining essential term
);

endmodule