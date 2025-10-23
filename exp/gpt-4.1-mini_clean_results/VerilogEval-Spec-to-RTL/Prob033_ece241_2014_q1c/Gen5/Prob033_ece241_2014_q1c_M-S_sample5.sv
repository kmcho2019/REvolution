module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    assign s = a + b;
    // Overflow if sign of a and b are the same but sign of s differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule