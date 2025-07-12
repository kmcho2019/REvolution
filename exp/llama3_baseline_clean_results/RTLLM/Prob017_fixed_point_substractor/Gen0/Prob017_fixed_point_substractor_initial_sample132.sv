module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of the input operands
    reg sign_a = a[N-1];  // Sign bit of 'a'
    reg sign_b = b[N-1];  // Sign bit of 'b'

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the fractional and integer parts
        res = a - b;

        // Maintain the same sign for the result
        if (res == 0) begin
            // Explicitly set the sign bit to 0 when the result is zero
            res[N-1] = 0;
        end else begin
            // Sign of the result will be the same as the inputs
            res[N-1] = sign_a;
        end
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0 && sign_b == 1'b1) begin
            // 'a' is positive and 'b' is negative, add the absolute values
            res = a + (~b + 1'b1);
            // Result sign depends on the relative sizes of 'a' and 'b'
            if (a >= (~b + 1'b1)) begin
                res[N-1] = 1'b0;  // Positive result
            end else begin
                res[N-1] = 1'b1;  // Negative result
            end
        end else if (sign_a == 1'b1 && sign_b == 1'b0) begin
            // 'a' is negative and 'b' is positive, add the absolute values
            res = (~a + 1'b1) + b;
            // Result sign depends on the relative sizes of 'a' and 'b'
            if ((~a + 1'b1) >= b) begin
                res[N-1] = 1'b1;  // Negative result
            end else begin
                res[N-1] = 1'b0;  // Positive result
            end
        end
    end

    // Assign the result to the output port
    c = res;
end

endmodule