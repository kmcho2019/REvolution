module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform addition directly (implicitly unsigned vectors, but addition is two's complement)
    assign s = a + b;

    // Overflow detection: overflow occurs if a[7] == b[7] but s[7] != a[7]
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule