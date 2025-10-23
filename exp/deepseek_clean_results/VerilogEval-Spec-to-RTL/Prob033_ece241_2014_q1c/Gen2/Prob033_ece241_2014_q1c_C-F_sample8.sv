module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct assignment of sum without intermediate wire
    assign s = a + b;
    
    // Optimized overflow detection with grouped operations
    assign overflow = (~a[7] & ~b[7] & s[7]) |  // Positive overflow
                     (a[7] & b[7] & ~s[7]);    // Negative underflow
endmodule