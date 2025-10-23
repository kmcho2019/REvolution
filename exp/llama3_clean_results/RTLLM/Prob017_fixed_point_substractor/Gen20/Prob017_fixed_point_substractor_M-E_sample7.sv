module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine signs of inputs
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Convert inputs to two's complement if negative
wire [N-1:0] a_two_comp = a_sign ? (~a + 1'b1) : a;
wire [N-1:0] b_two_comp = b_sign ? (~b + 1'b1) : b;

// Perform subtraction in two's complement domain
wire [N-1:0] diff;

// Same sign subtraction
wire [N-1:0] res_same_sign = a_sign ? (a_two_comp - b_two_comp) : (a_two_comp - b_two_comp);

// Different sign subtraction (effective addition)
wire [N-1:0] res_diff_sign = a_sign ? (a_two_comp + b) : (a + b_two_comp);

// Choose result based on sign comparison
assign diff = (a_sign == b_sign) ? res_same_sign : res_diff_sign;

// Adjust result to fixed-point format and handle zero case
assign c = (diff[N-1] == 1'b1) ? (~diff + 1'b1) : diff;

endmodule