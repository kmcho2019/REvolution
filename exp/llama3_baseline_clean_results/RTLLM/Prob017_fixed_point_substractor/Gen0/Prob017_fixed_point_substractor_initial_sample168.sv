module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional)
)
(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(a or b) begin
    // Determine the signs of the inputs
    logic a_sign = a[N-1];
    logic b_sign = b[N-1];

    // Same sign subtraction
    if (a_sign == b_sign) begin
        // Subtract the absolute values of a and b
        res = (a[N-1:0] - b[N-1:0]);
    end
    // Different sign subtraction
    else begin
        // Add the absolute values of a and b
        if (a[N-1:0] >= b[N-1:0]) begin
            // a is greater than or equal to b, result will have the same sign as a
            res = a[N-1:0] + (~b[N-1:0] + 1);
        end else begin
            // b is greater than a, result will have the opposite sign of a
            res = (~a[N-1:0] + 1) + b[N-1:0];
            res[N-1] = ~res[N-1];  // Invert the sign bit
        end
    end

    // Handle zero case
    if (res[N-1:0] == 0) begin
        res[N-1] = 0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule