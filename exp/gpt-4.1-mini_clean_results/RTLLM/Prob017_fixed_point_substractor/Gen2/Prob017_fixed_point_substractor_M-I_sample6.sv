// Fixed-point subtractor module with parameterized bit widths and fractional bits
module fixed_point_subtractor #(
    parameter integer N = 16, // Total bits (including sign)
    parameter integer Q = 8   // Number of fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Declare signed versions of inputs and output
    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);

    // Perform signed subtraction
    wire signed [N-1:0] signed_diff = signed_a - signed_b;

    // Result with sign bit forced to zero if zero result
    wire is_zero = (signed_diff == 0);
    wire [N-1:0] result = is_zero ? {{1'b0}, signed_diff[N-2:0]} : signed_diff;

    assign c = result;

endmodule