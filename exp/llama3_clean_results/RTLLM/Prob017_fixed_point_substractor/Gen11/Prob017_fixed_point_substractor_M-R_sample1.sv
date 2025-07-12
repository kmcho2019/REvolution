module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;  // Internal register to hold the result

assign res = a - b;  // Combinational logic assignment for subtraction
assign c = res;  // Assign result to output port

endmodule