module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform same sign subtraction
wire [N-1:0] same_sign_res = sign_a? (a + ~b + 1) : (a - b);

// Perform different sign subtraction
wire [N-1:0] different_sign_res = sign_a? (a + ~b + 1) : (a + ~b + 1);

// Handle the result based on the signs of the input operands
wire [N-1:0] res = (sign_a == sign_b)? same_sign_res : different_sign_res;

// Explicitly set the sign bit to 0 when the result is zero
assign c = (res == 0)? {N{1'b0}} : res;

endmodule