module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] sum;

    // Behavioral addition
    assign sum = a + b;
    assign s = sum;

    // Overflow detection for 2's complement:
    // Overflow occurs if a and b have same sign, but s has different sign.
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);
endmodule