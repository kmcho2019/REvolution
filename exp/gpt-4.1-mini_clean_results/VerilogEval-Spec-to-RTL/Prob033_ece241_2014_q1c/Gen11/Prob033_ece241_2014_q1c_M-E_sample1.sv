module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Perform addition using Verilog's + operator
    assign s = a + b;

    // Overflow detection for 2's complement addition:
    // Overflow if sign of a and b are the same, but sign of s is different
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule