module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

assign c = (a >= 0 && b >= 0) ? (a - b) : 
           (a < 0 && b < 0) ? (a - b) : 
           (a >= 0 && b < 0) ? (a + (~b + 1)) : 
           (a < 0 && b >= 0) ? ((~a + 1) + b);

endmodule