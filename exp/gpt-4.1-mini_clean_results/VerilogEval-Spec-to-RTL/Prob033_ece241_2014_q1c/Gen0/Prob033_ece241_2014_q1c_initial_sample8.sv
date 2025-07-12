module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [8:0] sum;
    assign sum = {1'b0, a} + {1'b0, b};
    assign s = sum[7:0];

    // Overflow detection:
    // Overflow occurs if the sign bits of a and b are the same,
    // but the sign bit of the result is different.
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule