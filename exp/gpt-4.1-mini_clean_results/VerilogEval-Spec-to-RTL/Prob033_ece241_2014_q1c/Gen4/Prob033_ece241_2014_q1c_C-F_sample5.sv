module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Sign-extend inputs to 9 bits for correct 2's complement addition and overflow detection
    wire signed [8:0] a_ext = {a[7], a};
    wire signed [8:0] b_ext = {b[7], b};

    // Perform 9-bit signed addition
    wire signed [8:0] sum_ext = a_ext + b_ext;

    // Output sum is the lower 8 bits
    assign s = sum_ext[7:0];

    // Overflow occurs if sign bits of inputs are equal and sign bit of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_ext[7]);

endmodule