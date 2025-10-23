module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Internal register to store the result of the subtraction
reg signed [N-1:0] res;

// Always block to perform the subtraction operation
always @(*) begin
    // Perform the subtraction operation and store the result in res
    res = a - b;

    // If the result is zero, explicitly set the sign bit to 0
    if (res == 0) begin
        res = 0;
    end
end

// Assign the output c the value of res
assign c = res;

endmodule