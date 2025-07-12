module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] sum;

    // Perform 8-bit addition
    assign sum = a + b;
    assign s = sum;

    // Overflow detection for signed addition:
    // overflow occurs when the carry into the sign bit differs from the carry out of the sign bit
    // or equivalently if sign of a and b are same and differ from sign of sum
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);

endmodule