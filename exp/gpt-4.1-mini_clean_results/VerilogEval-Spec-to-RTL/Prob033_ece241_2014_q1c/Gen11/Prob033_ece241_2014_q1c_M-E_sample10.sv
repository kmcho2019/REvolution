module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Cast inputs to signed 8-bit
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;

    // Perform addition
    wire signed [7:0] sum_signed = a_signed + b_signed;

    assign s = sum_signed;

    // Overflow detection for signed addition:
    // If sign of a and b are the same, but sign of sum differs => overflow
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_signed[7]);

endmodule