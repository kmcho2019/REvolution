module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] full_sum;

    assign full_sum = {1'b0, a} + {1'b0, b};
    assign s = full_sum[7:0];

    // Overflow detection for signed addition:
    // overflow if sign(a) == sign(b) && sign(s) != sign(a)
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
endmodule