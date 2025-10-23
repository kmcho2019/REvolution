module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c  // Declare output as wire for direct assignment
);

// Directly compute the result of subtraction and assign to output
assign c = a - b;

endmodule