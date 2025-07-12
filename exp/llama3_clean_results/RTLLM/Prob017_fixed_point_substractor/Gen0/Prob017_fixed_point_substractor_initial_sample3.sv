module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits (integer and fractional)
) (
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(*) begin
    // Check if the signs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > -b) begin
                res = a + (~b + 1);  // Add absolute values of a and b
            end else begin
                res = -(~a + 1) + b;  // Subtract absolute values of a and b
            end
        end else begin
            // a is negative, b is positive
            if (-a > b) begin
                res = -(~a + 1) + b;  // Subtract absolute values of a and b
            end else begin
                res = a + (~b + 1);  // Add absolute values of a and b
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule