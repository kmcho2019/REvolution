module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of a and b
    reg sign_a, sign_b;
    assign sign_a = a[N-1]; // MSB of a
    assign sign_b = b[N-1]; // MSB of b

    // Absolute Value Addition or Subtraction based on signs
    if (sign_a == sign_b) begin // Same signs
        // Absolute value addition
        res = a + b;
    end else begin // Different signs
        // Determine the larger absolute value
        if (a[N-1] == 1) begin // a is negative
            if (b > (~a + 1)) begin // b is larger
                res = b - (~a + 1); // b - (-a)
                // MSB of result will depend on the actual computation
            end else begin
                res = (~a + 1) - b; // -a - b, but since a is negative, it becomes a positive subtraction
                res = ~res + 1; // Convert back to two's complement
            end
        end else begin // b is negative
            if (a > (~b + 1)) begin // a is larger
                res = a - (~b + 1); // a - (-b)
            end else begin
                res = (~b + 1) - a; // -b - a, but since b is negative, it becomes a positive subtraction
                res = ~res + 1; // Convert back to two's complement
            end
        end
    end

    // Assign result to output, considering overflow
    if (res[N-1] == 1 && res[N-2:0] == {N-1{1'b0}}) begin // Check for maximum negative value
        c = {N{1'b1}}; // Saturate to maximum negative if overflow
    end else if (res[N-1] == 0 && res[N-2:0] == {N-1{1'b1}}) begin // Check for maximum positive value
        c = {1'b0, {N-1{1'b1}}}; // Saturate to maximum positive if overflow
    end else begin
        c = res; // No overflow, assign directly
    end
end

endmodule