module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire signed [N-1:0] a,    // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,    // Second fixed-point operand (signed two's complement)
    output wire signed [N-1:0] c     // Fixed-point addition result (signed two's complement)
);

    // Perform fixed-point addition directly on signed inputs
    // Note: Addition of two N-bit signed numbers produces an N-bit result
    // Overflow is implicitly handled by two's complement wrap-around (no saturation)
    assign c = a + b;

endmodule

/*
Summary:
- Inputs and outputs are signed fixed-point numbers (two's complement).
- Q fractional bits specify fixed-point resolution but do not affect addition logic.
- Addition uses native signed addition to correctly handle sign and magnitude.
- Overflow behavior is wrap-around per two's complement arithmetic.
- Minimal combinational logic with no additional registers or extension bits.
- This ensures optimal area and performance while maintaining correctness.
*/