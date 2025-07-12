module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Perform addition or subtraction based on sign bits
wire [N:0] result = (a[N-1] == b[N-1]) ? (a + b) : ((a[N-1]) ? (b - a) : (a - b));

// Check for overflow and assign the result
assign c = (result[N]) ? {1'b1, {N-1{1'b1}}} : result[N-1:0];

endmodule