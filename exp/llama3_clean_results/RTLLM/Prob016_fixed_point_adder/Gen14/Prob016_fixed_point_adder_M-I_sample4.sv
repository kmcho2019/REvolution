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

// Perform addition or subtraction based on the MSBs
wire [N:0] sum;
assign sum = (sign_a == sign_b) ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

// Handle overflow
wire [N-1:0] max_val = {1'b1, {N-1{1'b0}}};
wire overflow = (sum > {1'b0, max_val});
assign c = (overflow) ? max_val : sum[N-1:0];

// Set the sign of the result based on the signs of the inputs
assign c[N-1] = (sign_a == sign_b) ? sign_a : (abs_a > abs_b) ? 1'b0 : (sum[N-1:0] == 0) ? 1'b0 : 1'b1;

endmodule