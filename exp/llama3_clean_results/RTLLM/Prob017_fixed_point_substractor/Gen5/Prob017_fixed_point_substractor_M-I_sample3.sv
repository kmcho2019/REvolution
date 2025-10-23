module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

// Directly compute the result of subtraction and assign it to the output
always @(a or b) begin
    c = a - b;
end

endmodule