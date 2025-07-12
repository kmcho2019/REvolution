module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Perform 8-bit addition
    assign s = a + b;

    // Overflow detection for 2's complement addition:
    // Overflow if sign of a and b are equal but sign of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule