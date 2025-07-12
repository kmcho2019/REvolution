module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Internal register to store the result
reg signed [N-1:0] res;

// Combinational logic for subtraction
always @(*) begin
    res = a - b;
    // Explicitly handle the case when the result is zero
    if (res == 0) begin
        res = 0;  // Set the sign bit to 0
    end
    c = res;  // Assign the result to the output
end

endmodule