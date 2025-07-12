module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

// Calculate the result directly using combinational logic
wire [N-1:0] abs_a = a[N-1] ? (~a + 1) : a;
wire [N-1:0] abs_b = b[N-1] ? (~b + 1) : b;
wire [N-1:0] sum = (a[N-1] == b[N-1]) ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

// Determine the sign of the result
wire sign_c = (a[N-1] == b[N-1]) ? a[N-1] : (abs_a > abs_b) ? 1'b0 : (sum[N-1] == 1'b1 && sum[N-2:0] == 0) ? 1'b0 : 1'b1;

// Handle overflow by saturating the result
assign c = (sum[N-1] == 1'b1 && sign_c == 1'b1) ? {N{1'b1}} : 
           (sum[N-1] == 1'b0 && sign_c == 1'b0) ? {N{1'b0}} : 
           {sign_c, sum[N-2:0]};

endmodule