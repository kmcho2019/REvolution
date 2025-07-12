module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(a, b) begin
    // Directly compute the result based on the values of a and b
    // The subtraction operation inherently handles the signs
    c = a - b;
end

endmodule