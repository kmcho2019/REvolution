module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

wire [N:0] sum;
wire [N:0] diff_a_b;
wire [N:0] diff_b_a;

assign sum = a + b;
assign diff_a_b = a - b;
assign diff_b_a = b - a;

assign c = (a[N-1] == b[N-1]) ? 
           (sum >= (1 << N) ? (1 << N) - 1 : sum) :
           (a >= b) ? 
           (diff_a_b >= (1 << N) ? (1 << N) - 1 : diff_a_b) :
           (diff_b_a >= (1 << N) ? (1 << (N-1)) : (diff_b_a[N-1] ? {~diff_b_a[N-1], diff_b_a[N-1:0]} : diff_b_a));

endmodule