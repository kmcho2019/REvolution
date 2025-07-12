module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized NAND-based implementation
wire term1 = ~(~a & ~b & c & d);
wire term2 = ~(a & b & (~c | ~d));
wire term3 = ~(a & c & ~d);
wire term4 = ~(b & ~c & d);

assign out = ~(term1 & term2 & term3 & term4);

endmodule