module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

wire sign_a = a[N-1];
wire sign_b = b[N-1];

assign c = (sign_a == sign_b)? (a + b) : (a >= b)? (a - b) : (b - a);

endmodule