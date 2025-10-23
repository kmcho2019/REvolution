module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the sign bits of the input operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Compare the absolute values of a and b
    reg [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
    reg [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

    // Perform addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Same sign, perform addition
        res = a + b;
    end else begin
        // Different signs, perform subtraction
        if (abs_a > abs_b) begin
            // a is larger, subtract b from a
            res = (sign_a) ? ~(a + (~b + 1)) + 1 : a + (~b + 1);
        end else begin
            // b is larger, subtract a from b
            res = (sign_b) ? ~(b + (~a + 1)) + 1 : b + (~a + 1);
        end
    end

    // Check for overflow
    if (res[N-1] != sign_a && sign_a == sign_b) begin
        // Overflow occurred, set the result to the maximum or minimum value
        res = (sign_a) ? 32'h8000 : 32'h7fff;
    end

    // Assign the result to the output
    c = res;
end

endmodule