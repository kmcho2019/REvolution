module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Perform addition using Verilog '+' operator
    assign s = a + b;

    // Overflow detection:
    // Overflow occurs when the sign bits of a and b are the same,
    // but the sign bit of sum differs.
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
endmodule