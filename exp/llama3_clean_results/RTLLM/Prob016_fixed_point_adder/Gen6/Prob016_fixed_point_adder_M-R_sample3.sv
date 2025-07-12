module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine if the operands have the same sign
wire same_sign = (a[N-1] == b[N-1]);

// Calculate the absolute values of the operands
wire [N-1:0] abs_a = a[N-1] ? (~a + 1'b1) : a;
wire [N-1:0] abs_b = b[N-1] ? (~b + 1'b1) : b;

// Determine the sign of the result
wire sign = same_sign ? a[N-1] : (abs_a >= abs_b) ? a[N-1] : b[N-1];

// Perform addition or subtraction based on the signs
wire [N-1:0] res_abs = same_sign ? (a + b) : (abs_a >= abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);

// Handle overflow and underflow
wire [N-1:0] res = sign ? (~res_abs + 1'b1) : res_abs;

assign c = (res >= (1 << (N-1)) - 1) ? (1 << (N-1)) - 1 : (res < 0) ? 0 : res;

endmodule