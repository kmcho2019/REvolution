module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized implementation with factored common terms
wire term1 = ~(a | b) & c & d;    // !a & !b & c & d
wire term2 = b & d & ~c;           // b & d & !c
wire term3 = a & c & ~d;           // a & c & !d
wire term4 = a & b & ~(c | d);     // a & b & !c & !d

assign out = ~(term1 | term2 | term3 | term4);

endmodule