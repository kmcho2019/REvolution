module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the inputs
wire [N-1:0] abs_a = sign_a ? {1'b0, {N-1{1'b1}} ^ a} + 1 : a;
wire [N-1:0] abs_b = sign_b ? {1'b0, {N-1{1'b1}} ^ b} + 1 : b;

// Perform addition or subtraction based on the MSBs
wire add_op = sign_a == sign_b;
wire [N:0] sum = add_op ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

// Handle overflow
wire overflow = sum[N];

// Determine the sign of the result
wire sign_c = (add_op) ? sign_a : (abs_a > abs_b) ? 1'b0 : (sum[N-1] == 0 && sum[N-2:0] == 0) ? 1'b0 : 1'b1;

// Assign the result, handling overflow and sign
assign c = (overflow) ? {1'b1, {N-1{1'b1}}} : (sign_c) ? {1'b1, sum[N-1:1]} : {1'b0, sum[N-1:1]};

endmodule