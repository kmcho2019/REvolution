module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

wire sign_a = a[N-1];
wire sign_b = b[N-1];

wire [N:0] sum = a + b;
wire [N:0] diff_ab = a - b;
wire [N:0] diff_ba = b - a;

assign c = (sign_a == sign_b)? 
           (sum[N])? {N{1'b1}} : sum[N-1:0] : 
           (a >= b)? ((diff_ab[N])? {N{1'b1}} : diff_ab[N-1:0]) : 
           ((diff_ba[N])? {N{1'b1}} : diff_ba[N-1:0]);

endmodule