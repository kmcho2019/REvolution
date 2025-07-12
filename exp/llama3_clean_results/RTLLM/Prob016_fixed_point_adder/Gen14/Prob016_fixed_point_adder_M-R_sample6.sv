module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Split inputs into integer and fractional parts
wire [N-Q-1:0] int_a = a[N-1:N-Q];
wire [Q-1:0] frac_a = a[N-Q-1:0];
wire [N-Q-1:0] int_b = b[N-1:N-Q];
wire [Q-1:0] frac_b = b[N-Q-1:0];

// Calculate sum and difference of integer parts
wire [N-Q:0] int_sum = int_a + int_b;
wire [N-Q:0] int_diff_ab = int_a - int_b;
wire [N-Q:0] int_diff_ba = int_b - int_a;

// Calculate sum and difference of fractional parts
wire [Q:0] frac_sum = frac_a + frac_b;
wire [Q:0] frac_diff_ab = frac_a - frac_b;
wire [Q:0] frac_diff_ba = frac_b - frac_a;

// Determine result based on signs of a and b
assign c = (a[N-1] == b[N-1]) ? {int_sum[N-Q-1:0], frac_sum[Q-1:0]} :
           (a[N-1] == 1'b0 && int_a >= int_b) ? {1'b0, int_diff_ab, frac_diff_ab} :
           (a[N-1] == 1'b0 && int_a <  int_b) ? {1'b1, int_diff_ba, frac_diff_ba} :
           (a[N-1] == 1'b1 && int_a >= int_b) ? {1'b1, int_diff_ab, frac_diff_ab} :
           {1'b0, int_diff_ba, frac_diff_ba};

endmodule