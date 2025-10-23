module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin // a is positive, b is negative
        if (a >= -b) begin
            res = a + (~b + 1); // Add absolute values
        end else begin
            res = -(~a + 1) + b; // Result is negative
        end
    end else if (a[N-1] == 1 && b[N-1] == 0) begin // a is negative, b is positive
        if (-a >= b) begin
            res = -(~a + 1) - b; // Result is negative
        end else begin
            res = a + (~b + 1); // Result is positive
        end
    end
    
    // Handle the case when the result is zero
    if (res == 0) begin
        c = 0; // Set the sign bit to 0
    end else begin
        c = res;
    end
end

endmodule