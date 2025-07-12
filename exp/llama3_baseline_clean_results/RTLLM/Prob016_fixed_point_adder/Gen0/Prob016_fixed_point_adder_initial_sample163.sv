module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the result based on the signs of a and b
    if (a[N-1] == b[N-1]) begin
        // Both a and b have the same sign, perform absolute value addition
        res = a + b;
    end else begin
        // a and b have different signs, perform absolute value subtraction
        if (a[N-1] == 1) begin
            // a is negative
            if (b[N-1] == 0) begin
                // b is positive
                if (a > (~b + 1)) begin
                    // a is larger, result is a - b, but since a is negative, we are essentially doing b + a (with a being negative)
                    res = (~b + 1) + a;  // Note: This is essentially doing b + a with a being negative
                end else begin
                    // b is larger, result is b - a
                    res = b + (~a + 1);  // Note: This is essentially doing b - a with a being negative
                end
            end else begin
                // b is also negative
                res = a + b;  // Both negative, add them, the result will be negative
            end
        end else begin
            // b is negative
            if (a[N-1] == 0) begin
                // a is positive
                if (a > (~b + 1)) begin
                    // a is larger, result is a - b
                    res = a + (~b + 1);  // Note: This is essentially doing a - b with b being negative
                end else begin
                    // b is larger, result is b - a
                    res = (~b + 1) + a;  // Note: This is essentially doing b - a with b being negative
                end
            end else begin
                // a is also negative
                res = a + b;  // Both negative, add them, the result will be negative
            end
        end
    end

    // Ensure the result does not overflow
    if (res >= (1 << N)) begin
        // Overflow occurred, clamp the result to the maximum possible value
        res = (1 << N) - 1;
    end else if (res < 0) begin
        // Underflow occurred, clamp the result to the minimum possible value
        res = 0;
    end
end

assign c = res;

endmodule