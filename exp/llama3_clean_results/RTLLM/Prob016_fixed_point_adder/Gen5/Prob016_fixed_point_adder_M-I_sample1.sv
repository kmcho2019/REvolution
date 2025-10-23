module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform addition or subtraction based on the signs of a and b
wire [N:0] result;
assign result = (sign_a == sign_b)? (a + b) : 
                (a[N-1] == 1'b0 && b[N-1] == 1'b1)? (a - b) : 
                (a[N-1] == 1'b1 && b[N-1] == 1'b0)? (b - a) : 0;

// Handle overflow by checking the MSB of the result
assign c = (result[N] == sign_a)? result[N-1:0] : 
           (sign_a == 1'b0)? {1'b0, {N-1{1'b1}}} : {1'b1, {N-1{1'b0}}};

endmodule