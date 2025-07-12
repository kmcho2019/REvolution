module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(*) begin
    // Extract the sign bits of the input operands
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Same sign subtraction
    if (a_sign == b_sign) begin
        // Subtract the absolute values
        if (a_sign == 1) begin  // Both negative
            res = -a - b;
        end else begin  // Both positive
            res = a - b;
        end
    end else begin
        // Different sign subtraction
        if (a_sign == 1 && b_sign == 0) begin  // a is negative, b is positive
            if (a < -b) begin
                res = a - b;
            end else begin
                res = 0 - (b + a);
            end
        end else if (a_sign == 0 && b_sign == 1) begin  // a is positive, b is negative
            if (a > -b) begin
                res = a + b;
            end else begin
                res = 0 - (b - a);
            end
        end
    end

    // Handle the case when the result is zero
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule