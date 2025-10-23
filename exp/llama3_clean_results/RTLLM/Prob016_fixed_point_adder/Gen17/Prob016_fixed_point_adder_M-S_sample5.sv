module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Perform addition
wire [N:0] sum;
assign sum = a + b;

// Detect overflow and determine sign
wire overflow;
assign overflow = (sum[N] != a[N-1]) || (sum[N] != b[N-1]);

// Precision maintenance and result formation
assign c = (overflow)? {1'b1, {N-1{1'b0}}} : 
               ({sum[N], sum[N-1:0]});

endmodule