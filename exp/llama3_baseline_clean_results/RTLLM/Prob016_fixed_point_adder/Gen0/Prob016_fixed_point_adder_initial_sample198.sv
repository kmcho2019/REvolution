module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
)(
    input  [N-1:0] a,   // First N-bit fixed-point input operand
    input  [N-1:0] b,   // Second N-bit fixed-point input operand
    output [N-1:0] c    // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal register to store the result

always @(a or b) begin
    // Determine the sign of the result based on the signs of a and b
    if (a[N-1] == b[N-1]) begin
        // Both a and b have the same sign, add their absolute values
        if (a[N-1] == 1'b0) begin
            // Both a and b are positive, add them
            res = a + b;
            // Check for overflow and handle it
            if (res[N-1] == 1'b1) begin
                // Overflow occurred, set the MSB to 0 and truncate the extra bit
                res = {1'b0, res[N-2:0]};
            end
        end else begin
            // Both a and b are negative, add their absolute values and keep the sign
            res = (a + b);
        end
    end else begin
        // a and b have different signs, perform absolute value subtraction
        if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            if (a < b) begin
                // b is greater, subtract a from b and set the sign to 0 (positive)
                res = b - (a);
                // Check for underflow and handle it
                if (res[N-1] == 1'b1) begin
                    // Underflow occurred, set the result to 0
                    res = 0;
                end
            end else begin
                // a is greater, subtract b from a and keep the sign (negative)
                res = (a - b);
            end
        end else begin
            // a is positive, b is negative
            if (a < b) begin
                // b is greater, subtract a from b and set the sign to 1 (negative)
                res = (b - a);
            end else begin
                // a is greater, subtract b from a and set the sign to 0 (positive)
                res = a - (b);
            end
        end
    end
    // Assign the result to the output
    c = res;
end

endmodule