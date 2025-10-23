module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the inputs
wire [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
wire [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

// Determine if the MSBs are the same
wire same_sign = sign_a == sign_b;

// Perform addition or subtraction based on the MSBs
wire [N:0] sum;
assign sum = (same_sign) ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

// Handle overflow
wire overflow = sum[N];
assign c = (overflow) ? {1'b1, {N-1{1'b0}}} : sum[N-1:0];

// Set the sign of the result based on the signs of the inputs
// If the signs are the same, the result has the same sign
// If the signs are different, the result is positive if the larger absolute value is positive, negative otherwise
assign c[N-1] = (same_sign) ? sign_a : (abs_a > abs_b) ? 1'b0 : (sum[N-1:0] == 0) ? 1'b0 : 1'b1;

endmodule