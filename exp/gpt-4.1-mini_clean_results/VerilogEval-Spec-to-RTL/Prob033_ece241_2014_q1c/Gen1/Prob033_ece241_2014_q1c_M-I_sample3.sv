module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Perform 8-bit addition
    assign s = a + b;

    // Overflow detection for signed addition:
    // Overflow occurs if sign bits of a and b are the same but differ from s
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule