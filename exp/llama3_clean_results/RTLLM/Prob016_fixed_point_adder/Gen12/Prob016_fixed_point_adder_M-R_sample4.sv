module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Calculate the sum of the two input operands
wire [N:0] sum;
assign sum = a + b;

// Determine the sign bit of the result based on the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];
wire sign_c = (sign_a == sign_b) ? sign_a : (sum[N] ? 1'b1 : 1'b0);

// Handle overflow by saturating at the maximum value if necessary
wire [N-1:0] result;
assign result = (sum[N]) ? {N{1'b1}} : sum[N-1:0];

// Assign the final result with the correct sign bit
assign c = {sign_c, result[N-2:0]};

endmodule