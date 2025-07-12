module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Directly add the two input operands
wire [N:0] sum;
assign sum = a + b;

// Handle overflow and assign the result
assign c = (sum[N]) ? {N{1'b1}} : sum[N-1:0];

// Alternative approach using conditional operator
// assign c = (sum > {N{1'b1}}) ? {N{1'b1}} : sum[N-1:0];

endmodule