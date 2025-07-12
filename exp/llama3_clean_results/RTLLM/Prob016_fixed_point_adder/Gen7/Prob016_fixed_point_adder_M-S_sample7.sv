module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Directly compute the result
wire [N:0] sum = a + b;
wire [N:0] diff = a - b;

// Determine the result based on the signs of a and b
assign c = (a[N-1] == b[N-1])? 
    (a[N-1]? {a[N-1], diff[N-1:0]} : {a[N-1], sum[N-1:0]}) : 
    (a[N-1]? {1'b1, diff[N-1:0]} : {1'b0, sum[N-1:0]});

// Optional: you can add overflow handling as needed
// assign c = (sum[N] || diff[N])? ((sum[N] && a[N-1])? (1 << N) - 1 : 0) : c;

endmodule