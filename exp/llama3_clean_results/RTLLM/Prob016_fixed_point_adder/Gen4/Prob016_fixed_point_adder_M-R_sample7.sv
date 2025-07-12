module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Calculate the result based on the signs of a and b
assign c = (a[N-1] == b[N-1]) ? 
           (a + b) : 
           (a >= b) ? (a - b) : (b - a);

endmodule