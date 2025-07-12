module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum = {1'b0, a} + {1'b0, b}; // add with zero-extended to 9 bits for sum capturing

    assign s = sum[7:0];
    // overflow if a and b have the same sign but sum has different sign
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule