module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Internal register to store the result of the subtraction operation
reg signed [N-1:0] res;

// Always block for combinational logic (subtraction)
always @(*) begin
    // Perform subtraction and store the result in the internal register
    res = a - b;
end

// Continuous assignment for output
assign c = res;

endmodule