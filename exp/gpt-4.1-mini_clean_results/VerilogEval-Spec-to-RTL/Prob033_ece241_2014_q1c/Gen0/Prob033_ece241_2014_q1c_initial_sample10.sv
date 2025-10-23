module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Convert inputs to signed
    wire signed [8:0] a_ext = {a[7], a}; // sign-extend to 9 bits
    wire signed [8:0] b_ext = {b[7], b}; // sign-extend to 9 bits

    wire signed [8:0] sum_ext = a_ext + b_ext; // 9-bit signed sum

    assign s = sum_ext[7:0];

    // Overflow detection for signed addition:
    // Overflow occurs if sign of a == sign of b and sign of sum != sign of a
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_ext[7]);

endmodule