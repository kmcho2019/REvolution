module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits (both integer and fractional)
) (
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform same-sign subtraction
    if (sign_a == sign_b) begin
        res = a - b;
    end
    // Perform different-sign subtraction
    else begin
        // If a is positive and b is negative
        if (~sign_a && sign_b) begin
            // Add the absolute values of a and b
            res = a + (~b + 1'b1);
            // Determine the sign of the result
            if (a > (~b + 1'b1)) begin
                res[N-1] = 0; // Positive sign
            end else begin
                res[N-1] = 1; // Negative sign
            end
        end
        // If a is negative and b is positive
        else begin
            // Add the absolute values of a and b
            res = (~a + 1'b1) + b;
            // Determine the sign of the result
            if ((~a + 1'b1) > b) begin
                res[N-1] = 1; // Negative sign
            end else begin
                res[N-1] = 0; // Positive sign
            end
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 0; // Explicitly set the sign bit to 0
    end

    // Assign the result to the output port
    c = res;
end

endmodule