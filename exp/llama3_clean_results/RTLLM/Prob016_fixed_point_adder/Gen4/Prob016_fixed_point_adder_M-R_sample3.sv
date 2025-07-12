module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of a and b
wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

// Perform addition or subtraction based on the signs of a and b
wire [N:0] result;
assign result = (sign_a == sign_b) ? (a + b) : 
                (abs_a >= abs_b) ? (sign_a == 1'b0) ? (a - b) : (1'b0 - (b - a)) : 
                (sign_b == 1'b0) ? (b - a) : (1'b0 - (a - b));

// Handle overflow by saturating the result
assign c = (result[N] == 1'b1) ? ((1 << (N-1)) - 1) : (result[N-1:0]);

endmodule