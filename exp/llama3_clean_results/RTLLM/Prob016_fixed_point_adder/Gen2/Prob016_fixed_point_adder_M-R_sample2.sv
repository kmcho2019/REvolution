module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

// Perform addition or subtraction based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        // Perform absolute value addition
        c = a + b;
    end else begin // Different signs
        // Perform absolute value subtraction
        if (a >= b) begin
            c = a - b;
        end else begin
            c = b - a;
        end
    end
    
    // Handle overflow by checking the MSB of the result
    if (c[N-1] != a[N-1] && c[N-1] != b[N-1]) begin
        // Adjust the result to prevent overflow
        if (a[N-1] == 1'b0) begin // a is positive
            c = {1'b0, {N-1{1'b1}}}; // Set result to maximum positive value
        end else begin // a is negative
            c = {1'b1, {N-1{1'b0}}}; // Set result to minimum negative value
        end
    end
end

endmodule