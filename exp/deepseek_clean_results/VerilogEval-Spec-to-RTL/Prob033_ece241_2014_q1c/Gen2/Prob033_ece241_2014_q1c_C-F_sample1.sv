module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct 8-bit addition
    assign s = a + b;
    
    // Overflow occurs when:
    // 1. Input signs are equal (both positive or both negative)
    // 2. Result sign differs from input signs
    assign overflow = (a[7] == b[7]) & (a[7] != s[7]);
endmodule