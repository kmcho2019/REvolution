module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of a and b
    wire sign_a = a[N-1];  // Sign bit of a
    wire sign_b = b[N-1];  // Sign bit of b

    // Perform same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the fractional and integer parts
        res = a - b;
    end
    // Perform different sign subtraction
    else begin
        // Compare the absolute values of a and b to determine the sign of the result
        if (a[N-1] == 1'b0) begin  // a is positive
            if (b[N-1] == 1'b1) begin  // b is negative
                // Add the absolute values of a and b
                res = a + (~b + 1'b1);
            end
        end
        else begin  // a is negative
            if (b[N-1] == 1'b0) begin  // b is positive
                // Add the absolute values of a and b
                res = (~a + 1'b1) + b;
            end
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule