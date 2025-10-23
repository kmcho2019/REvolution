module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire signed [8:0] sum_ext;

    // Perform signed addition with extra bit for carry out
    assign sum_ext = $signed(a) + $signed(b);

    // Sum is lower 8 bits
    assign s = sum_ext[7:0];

    // Overflow detection for 2's complement addition:
    // Overflow occurs if a and b have the same sign but sum has different sign.
    assign overflow = (~a[7] & ~b[7] & sum_ext[7]) | (a[7] & b[7] & ~sum_ext[7]);

endmodule