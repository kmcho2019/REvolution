module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform the arithmetic operation directly based on signs
wire [N:0] result;
assign result = (sign_a == sign_b)? (a + b) : ((sign_a == 1'b0)? (a - b) : (b - a));

// Handle overflow by checking the MSB of the result
wire [N-1:0] res_int;
assign res_int = (result[N] == 1'b0)? result[N-1:0] : ((sign_a == 1'b0)? {1'b0, {N-1{1'b1}}} : {1'b1, {N-1{1'b0}}});
assign c = res_int;

endmodule