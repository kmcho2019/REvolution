module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the operation is an addition or subtraction
wire add_op = (sign_a == sign_b);

// Perform the arithmetic operation
wire [N:0] result;
assign result = add_op? (a + b) : (sign_a == 1'b0)? (a - b) : (b - a);

// Handle overflow by checking the carry-out of the arithmetic operation
wire overflow = result[N];
assign c = overflow? (sign_a == 1'b0)? {1'b0, {N-1{1'b1}}} : {1'b1, {N-1{1'b0}}} : result[N-1:0];

endmodule