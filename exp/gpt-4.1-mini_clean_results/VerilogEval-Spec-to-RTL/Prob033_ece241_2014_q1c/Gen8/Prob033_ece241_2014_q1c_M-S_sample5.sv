module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum;  // 9-bit sum to capture carry out

    assign sum = a + b;    // 8-bit addition with carry-out in sum[8]
    assign s = sum[7:0];   // lower 8 bits is the result sum

    // Overflow occurs if sign bits of a and b are the same, but differ from sum
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);

endmodule