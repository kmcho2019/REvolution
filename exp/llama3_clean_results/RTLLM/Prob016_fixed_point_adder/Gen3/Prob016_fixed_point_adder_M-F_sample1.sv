module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

// Internal register to store the result
reg [N-1:0] res;

// Perform addition or subtraction based on the signs of a and b
always @(*) begin
    // Check if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Perform absolute value addition
        res = a + b;
    end else begin
        // Perform absolute value subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Handle overflow by checking the MSB of the result
    if (res[N-1] != a[N-1] && res[N-1] != b[N-1]) begin
        // Adjust the result to prevent overflow
        if (a[N-1] == 1'b0) begin // a is positive
            res = {1'b0, {N-1{1'b1}}}; // Set result to maximum positive value
        end else begin // a is negative
            res = {1'b1, {N-1{1'b0}}}; // Set result to minimum negative value
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule