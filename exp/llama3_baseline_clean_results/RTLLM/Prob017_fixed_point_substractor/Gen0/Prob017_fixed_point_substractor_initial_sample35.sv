module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a, // First fixed-point input operand
    input  [N-1:0] b, // Second fixed-point input operand
    output [N-1:0] c  // Fixed-point output result
);

reg [N-1:0] res; // Internal register to store the result

// Determine the sign of the input operands
wire sign_a = a[N-1]; // Sign bit of operand a
wire sign_b = b[N-1]; // Sign bit of operand b

// Perform same sign subtraction
wire [N-1:0] same_sign_res = (sign_a == sign_b)? (a - b) : 'z;

// Perform different sign subtraction
wire [N-1:0] abs_a = sign_a? (~a + 1) : a; // Absolute value of a
wire [N-1:0] abs_b = sign_b? (~b + 1) : b; // Absolute value of b
wire [N-1:0] diff_sign_res = (sign_a == sign_b)? 'z : (abs_a > abs_b)? (abs_a - abs_b) : (abs_b - abs_a);

// Combine the results of same sign and different sign subtraction
assign res = (sign_a == sign_b)? same_sign_res : diff_sign_res;

// Handle the edge case where the result is zero
assign c = (res == 0)? {N{1'b0}} : res;

endmodule