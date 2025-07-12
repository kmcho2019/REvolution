module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

wire [N-1:0] sum;
wire [N-1:0] diff_ab;
wire [N-1:0] diff_ba;

// Determine the sum and differences
assign sum = a + b;
assign diff_ab = a + (~b + 1); // a - b
assign diff_ba = (~a + 1) + b; // b - a

// Determine the result based on the signs of a and b
wire [N-1:0] res = (a[N-1] == b[N-1]) ? sum : (a[N-1] == 0) ? diff_ab : diff_ba;

// Saturate the result to handle overflows
assign c = (res[N-1] && ~a[N-1] && ~b[N-1]) ? {1'b1, {(N-1){1'b1}} :
             (~res[N-1] && a[N-1] && b[N-1]) ? {1'b0, {(N-1){1'b0}} :
             res;

endmodule