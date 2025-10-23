module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [7:0] sum_signed;

    assign sum_signed = a_signed + b_signed;
    assign s = sum_signed;

    // Overflow if a and b have same sign but sum has different sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule