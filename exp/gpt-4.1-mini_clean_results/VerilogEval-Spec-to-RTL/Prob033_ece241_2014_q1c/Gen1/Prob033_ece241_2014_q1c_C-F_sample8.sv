module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Cast inputs to signed for proper signed addition
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_ext;

    assign sum_ext = a_signed + b_signed;
    assign s = sum_ext[7:0];

    // Overflow occurs if sign of a and b are the same but differs from sign of sum
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule