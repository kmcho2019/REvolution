module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Perform addition using Verilog built-in operator
    assign s = a + b;

    // Overflow detection for signed addition:
    // If sign of a and b are same but sign of sum differs, overflow occurred.
    wire a_sign = a[7];
    wire b_sign = b[7];
    wire s_sign = s[7];

    assign overflow = (~(a_sign ^ b_sign)) & (a_sign ^ s_sign);

endmodule