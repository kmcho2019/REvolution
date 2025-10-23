module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct 8-bit addition
    assign s = a + b;
    
    // Overflow occurs when:
    // 1. Adding two positives gives negative (sign bit set)
    // 2. Adding two negatives gives positive (sign bit clear)
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
endmodule