module TopModule (
    input x,
    input y,
    output z
);
    // Optimized implementation using XOR property
    assign z = x & (x ^ y);
endmodule