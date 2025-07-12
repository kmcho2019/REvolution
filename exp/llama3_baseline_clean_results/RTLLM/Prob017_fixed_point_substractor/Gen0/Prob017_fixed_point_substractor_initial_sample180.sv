module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the two numbers
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // Determine the sign of the result
        if ((~sign_a & ~sign_b) || (sign_a && (~b[N-2:0] == 0))) begin
            // a is positive and b is negative, or a is negative and b is positive with b's value being zero
            if (a[N-2:0] > b[N-2:0]) begin
                res = a + (~b + 1);  // Two's complement of b and add to a
            end else if (a[N-2:0] < b[N-2:0]) begin
                res = (~a + 1) + b;  // Two's complement of a and add to b
            end else begin
                res = 0;  // Result is zero
            end
        end else begin
            // a is negative and b is positive with b's value being non-zero, or a is positive and b is negative with a's value being zero
            if (a[N-2:0] > b[N-2:0]) begin
                res = a + (~b + 1);  // Two's complement of b and add to a
            end else if (a[N-2:0] < b[N-2:0]) begin
                res = (~a + 1) + b;  // Two's complement of a and add to b
            end else begin
                res = 0;  // Result is zero
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