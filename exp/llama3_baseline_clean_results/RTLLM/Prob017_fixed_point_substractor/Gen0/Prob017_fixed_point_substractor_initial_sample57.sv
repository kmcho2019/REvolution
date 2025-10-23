module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine the signs of a and b
    reg a_sign, b_sign;
    a_sign = a[N-1];
    b_sign = b[N-1];

    // Same sign subtraction
    if (a_sign == b_sign) begin
        // Subtract the two numbers
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // Compare the absolute values of a and b
        reg [N-1:0] a_abs, b_abs;
        a_abs = (a_sign) ? (~a + 1) : a;
        b_abs = (b_sign) ? (~b + 1) : b;

        if (a_abs >= b_abs) begin
            // Result is positive if a is greater than or equal to b
            res = a_abs - b_abs;
        end
        else begin
            // Result is negative if a is less than b
            res = b_abs - a_abs;
            // Set the sign bit to 1 (negative)
            res[N-1] = 1;
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 0;  // Set the sign bit to 0 (positive)
    end

    c = res;
end

endmodule