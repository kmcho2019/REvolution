module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the sign of the result
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform addition or subtraction based on signs
wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

wire [N-1:0] res;
assign res = (sign_a == sign_b) ? (abs_a + abs_b) : 
              (abs_a > abs_b) ? (abs_a - abs_b) : 
              (abs_b - abs_a);

// Handle overflow and set the sign of the result
assign c = (res[N-1] && ~sign_a && ~sign_b) ? {1'b1, {N-1{1'b1}}} : 
          (~res[N-1] && sign_a && sign_b) ? {1'b0, {N-1{1'b0}}} : 
          (sign_a == sign_b) ? {sign_a, res[N-2:0]} : 
          (abs_a > abs_b) ? {1'b0, res[N-1:0]} : 
          {res[N-1], res[N-2:0]};

endmodule