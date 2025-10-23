module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Perform addition or subtraction based on the signs of a and b
assign c = (a[N-1] == b[N-1])? (a + b) : 
           ((a[N-1] == 1'b0 && a >= b) || (a[N-1] == 1'b1 && b >= a))? 
           (a[N-1] == 1'b0)? a - b : (1'b0 - (b - a)) : 
           (a[N-1] == 1'b0)? b - a : (1'b0 - (a - b));

// Handle overflow by saturating the result
assign c = (c[N-1] == 1'b1)? ((1 << (N-1)) - 1) : (c[N-1] == 1'b0 && c[N-1] == 1'b1)? 0 : c[N-1:0];

endmodule