module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum = a_signed + b_signed;

    assign s = sum[7:0];
    // Overflow occurs if sign of a and b are same but different from sum sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);

endmodule