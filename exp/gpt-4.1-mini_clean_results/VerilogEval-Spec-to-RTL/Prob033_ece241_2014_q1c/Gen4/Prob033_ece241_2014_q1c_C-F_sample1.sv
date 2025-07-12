module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform 8-bit two's complement addition directly
    assign s = a + b;

    // Overflow detection: occurs if sign bits of a and b match, but differ from s's sign bit
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule