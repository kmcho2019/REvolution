module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

// Split the input operands into integer and fractional parts
wire [N-Q-1:0] int_a;
wire [N-Q-1:0] int_b;
wire [Q-1:0] frac_a;
wire [Q-1:0] frac_b;

assign int_a = a[N-1:Q];
assign int_b = b[N-1:Q];
assign frac_a = a[Q-1:0];
assign frac_b = b[Q-1:0];

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform subtraction operation for integer part
wire [N-Q:0] int_res;
wire int_cout;

assign int_res = sign_a == sign_b ? (sign_a ? -int_a + -int_b : int_a - int_b) : (sign_a ? -int_a + int_b : int_a + -int_b);

// Perform subtraction operation for fractional part
wire [Q:0] frac_res;
wire frac_cout;

assign frac_res = sign_a == sign_b ? (sign_a ? -frac_a + -frac_b : frac_a - frac_b) : (sign_a ? -frac_a + frac_b : frac_a + -frac_b);

// Combine the integer and fractional parts
wire [N:0] res;
assign res = {int_res, frac_res[Q-1:0]};

// Handle the sign bit logic
wire sign_res;
assign sign_res = res[N] ? 1'b1 : 1'b0;

// Assign the result to the output port
assign c = {sign_res, res[N-1:0]};

endmodule