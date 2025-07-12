module fixed_point_adder #(
    parameter N = 16,  // Total number of bits
    parameter Q = 8    // Number of fractional bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Compare the signs
wire same_sign = sign_a == sign_b;

// Calculate absolute values
wire [N-1:0] abs_a = sign_a ? -a : a;
wire [N-1:0] abs_b = sign_b ? -b : b;

// Perform addition if signs are the same
wire [N-1:0] add_res = abs_a + abs_b;

// Determine the larger absolute value for subtraction
wire larger_a = abs_a > abs_b;
wire [N-1:0] sub_res = larger_a ? abs_a - abs_b : abs_b - abs_a;

// Set the sign of the result for subtraction
wire sub_sign = larger_a ? sign_a : sign_b;

// Select between addition and subtraction results
assign res = same_sign ? add_res : (sub_sign ? -sub_res : sub_res);

// Assign the result to output, handling overflow
assign c = res[N-1] ? {N{1'b1}} : res;

endmodule