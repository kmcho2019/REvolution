module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits (integer + fractional)
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

// Calculate the result based on the signs of the inputs
always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            if (a < (~b + 1'b1)) begin
                res = (~b + 1'b1) - a;
                res[N-1] = 1'b1;  // Set sign bit to negative
            end else begin
                res = a - (~b + 1'b1);
                res[N-1] = 1'b0;  // Set sign bit to positive
            end
        end else begin  // a is negative, b is positive
            if ((~a + 1'b1) < b) begin
                res = b - (~a + 1'b1);
                res[N-1] = 1'b0;  // Set sign bit to positive
            end else begin
                res = (~a + 1'b1) - b;
                res[N-1] = 1'b1;  // Set sign bit to negative
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 for zero result
    end
end

assign c = res;

endmodule