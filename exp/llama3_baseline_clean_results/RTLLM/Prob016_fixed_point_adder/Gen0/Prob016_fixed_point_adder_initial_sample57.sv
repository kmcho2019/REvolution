module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine signs of operands
    reg sign_a = a[N-1];  // Sign bit of operand a
    reg sign_b = b[N-1];  // Sign bit of operand b

    // Extract absolute values
    reg [N-1:0] abs_a = (sign_a)? (~a + 1) : a;  // Absolute value of a
    reg [N-1:0] abs_b = (sign_b)? (~b + 1) : b;  // Absolute value of b

    if (sign_a == sign_b) begin
        // Same signs, add absolute values
        res = (abs_a + abs_b);
        // Set sign of result to match operands
        if (sign_a) begin
            // Both operands were negative
            if (res[N-1] == 0) begin
                // Result is positive, convert to negative
                res = (~res + 1);
            end
        end
    end else begin
        // Different signs, subtract smaller from larger
        if (abs_a > abs_b) begin
            // a is larger
            res = (abs_a - abs_b);
            // Result is positive
            if (res[N-1] == 1) begin
                // Result is negative, convert to positive
                res = (~res + 1);
            end
        end else if (abs_b > abs_a) begin
            // b is larger
            res = (abs_b - abs_a);
            // Result is positive, no need to flip
        end else begin
            // a and b have the same absolute value
            res = 0;
        end
    end

    // Handle overflow
    if (res[N-1] == 1 && sign_a == 0) begin
        // Overflow for positive result
        res = {1'b1, {N-1{1'b1}}};
    end else if (res[N-1] == 0 && sign_a == 1) begin
        // Underflow for negative result
        res = {N{1'b0}};
    end
end

assign c = res;

endmodule