module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Preprocessing stage: Determine the absolute values
wire signed [N-1:0] abs_a;
wire signed [N-1:0] abs_b;

assign abs_a = (sign_a)? -a : a;  // Simplified absolute value calculation
assign abs_b = (sign_b)? -b : b;  // Simplified absolute value calculation

// Core computation stage using continuous assignments
wire signed [N-1:0] same_sign_result;
wire signed [N-1:0] different_sign_result;

assign same_sign_result = a - b;

assign different_sign_result = (abs_a > abs_b)? (abs_a - abs_b) : -(abs_b - abs_a);

// Select the result based on the signs of the inputs
assign c = (sign_a == sign_b)? same_sign_result : different_sign_result;

// Explicitly handle the case where the result is zero
assign c = (c == 0)? 0 : c;

endmodule