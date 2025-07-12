module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized implementation using XOR patterns observed in K-map
assign out = (a ^ c) | (b ^ d);

endmodule