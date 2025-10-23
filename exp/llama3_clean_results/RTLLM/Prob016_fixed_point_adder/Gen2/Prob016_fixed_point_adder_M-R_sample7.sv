module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Internal wire to hold the result of addition or subtraction
wire [N:0] res;

// Perform addition or subtraction based on the signs of a and b
assign res = (a[N-1] == b[N-1]) ? (a + b) : ((a[N-1] == 1'b0) ? (a - b) : (b - a));

// Assign the result to output c, handling overflow and underflow
assign c = (res[N] == 1'b1) ? ((1 << (N-1)) - 1) : (res[N] == 1'b0 && res[N-1] == 1'b1) ? 0 : res[N-1:0];

endmodule