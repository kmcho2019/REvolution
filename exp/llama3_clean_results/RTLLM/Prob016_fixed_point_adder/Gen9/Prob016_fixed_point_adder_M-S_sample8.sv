module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Calculate the result based on the signs of a and b
wire [N:0] sum = (a_sign == b_sign)? (a + b) : ((a[N-1] == 1'b0 && a > b) || (a[N-1] == 1'b1 && a < b))? (a - b) : (b - a);

// Assign the result to the output, handling overflow
assign c = (sum[N])? {1'b0, sum[N-1:0]} : sum[N-1:0];

endmodule