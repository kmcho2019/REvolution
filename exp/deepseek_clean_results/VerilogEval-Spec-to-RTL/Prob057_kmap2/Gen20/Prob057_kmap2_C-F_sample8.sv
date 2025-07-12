module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized implementation combining pattern recognition and Boolean optimization
assign out = (~c & ~(a & b)) |          // Covers cd=00,01 except ab=11
             (c & d & ~(~a & ~b)) |     // Covers cd=11 except ab=00
             (c & ~d & (~a | (a & ~b))); // Covers cd=10 when ab=00 or 01

endmodule