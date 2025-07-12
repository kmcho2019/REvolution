// Fixed-point subtractor module with parameterized total and fractional bits
module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bit width including sign bit
    parameter integer Q = 8    // Number of fractional bits
)(
    input  wire [N-1:0] a,    // Fixed-point input operand a
    input  wire [N-1:0] b,    // Fixed-point input operand b
    output wire [N-1:0] c     // Fixed-point output result c = a - b
);

    // Cast inputs to signed for two's complement arithmetic
    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);

    // Perform signed subtraction
    wire signed [N-1:0] signed_diff = signed_a - signed_b;

    // Check if the result is zero
    wire is_zero = (signed_diff == 0);

    // If zero, force sign bit to 0; else keep as is
    // This keeps integer and fractional bits intact, only modifies sign bit when zero.
    assign c = is_zero ? {1'b0, signed_diff[N-2:0]} : signed_diff;

endmodule