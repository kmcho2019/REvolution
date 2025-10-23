module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the result based on the signs of a and b
wire [N:0] sum = (a[N-1] == b[N-1])? (a + b) : (a[N-1]? (b - a) : (a - b));

// Handle overflow and assign the result
assign c = (sum[N])? {1'b1, {N-1{1'b1}}} : sum[N-1:0];

endmodule