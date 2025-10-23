module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the sign of the result
wire signed [N-1:0] res;

assign res = (a[N-1] == b[N-1]) ? (a + b) : (a[N-1] == 0) ? (a - (~b + 1)) : ((~a + 1) + b);

// Saturate the result to handle overflows
assign c = (res[N-1] && ~a[N-1] && ~b[N-1]) ? {1'b1, {N-1{1'b1}}} : 
          (~res[N-1] && a[N-1] && b[N-1]) ? {1'b1, {N-1{1'b0}}} : 
          res;

endmodule