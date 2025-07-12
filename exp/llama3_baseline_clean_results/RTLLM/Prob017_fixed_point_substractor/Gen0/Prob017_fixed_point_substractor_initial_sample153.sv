module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

// Determine the signs of the input operands
wire a_sign = a[N-1];  // Sign bit of 'a'
wire b_sign = b[N-1];  // Sign bit of 'b'

// Perform subtraction based on the signs
always @(*) begin
    if (a_sign == b_sign) begin
        // Same sign subtraction
        res = a - b;
    end else if (a_sign == 1'b0 && b_sign == 1'b1) begin
        // 'a' is positive, 'b' is negative
        res = a + (~b + 1'b1);  // Add the absolute values
    end else begin
        // 'a' is negative, 'b' is positive
        res = (~a + 1'b1) + b;  // Add the absolute values
    end
    
    // Handle the edge case where the result is zero
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0 for zero result
    end
end

// Output the result
assign c = res;

endmodule