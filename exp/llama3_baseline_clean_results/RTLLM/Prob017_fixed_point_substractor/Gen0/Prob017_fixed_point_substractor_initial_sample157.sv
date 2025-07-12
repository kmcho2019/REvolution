module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

// Determine the sign of the inputs
wire sign_a = a[N-1];  // Sign bit of input a
wire sign_b = b[N-1];  // Sign bit of input b

// Perform same sign subtraction
wire [N-1:0] same_sign_res = (a[N-1] == b[N-1]) ? (a - b) : {N{1'b0}};

// Perform different sign subtraction
wire [N-1:0] diff_sign_res_a_gt_b = (a[N-1] == 1'b0 && b[N-1] == 1'b1 && a > (~b + 1'b1)) ? (a + (~b + 1'b1)) : {N{1'b0}};
wire [N-1:0] diff_sign_res_b_gt_a = (a[N-1] == 1'b1 && b[N-1] == 1'b0 && (~a + 1'b1) > b) ? (~a + 1'b1 + b) : {N{1'b0}};

// Select the correct result based on the signs of the inputs
wire [N-1:0] temp_res = (sign_a == sign_b) ? same_sign_res : (sign_a == 1'b0 && sign_b == 1'b1) ? diff_sign_res_a_gt_b : diff_sign_res_b_gt_a;

// Handle the zero result case
assign res = (temp_res == {N{1'b0}}) ? {N{1'b0}} : temp_res;

// Assign the result to the output port
assign c = res;

endmodule