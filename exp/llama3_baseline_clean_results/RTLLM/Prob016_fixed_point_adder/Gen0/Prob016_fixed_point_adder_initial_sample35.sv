module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(a, b) begin
    // Determine the sign bits of the input operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Compare the signs of a and b to decide whether to perform addition or subtraction
    if (sign_a == sign_b) begin
        // Perform addition
        if (sign_a) begin
            // Both a and b are negative, add their absolute values and set the sign bit
            res = -a - b;
        end else begin
            // Both a and b are positive, add their absolute values and set the sign bit
            res = a + b;
        end
    end else begin
        // Perform subtraction
        if (sign_a) begin
            // a is negative, b is positive
            if (a < -b) begin
                // a is greater than b in absolute value, result is a - b and negative
                res = a - b;
            end else begin
                // b is greater than a in absolute value, result is b - a and positive
                res = b - a;
            end
        end else begin
            // a is positive, b is negative
            if (a > -b) begin
                // a is greater than b in absolute value, result is a - b and positive
                res = a - b;
            end else begin
                // b is greater than a in absolute value, result is b - a and negative
                res = b - a;
            end
        end
    end

    // Handle overflow by checking if the result exceeds the N-bit range
    if (res >= (1 << N)) begin
        // Overflow, set the result to the maximum N-bit value
        res = (1 << N) - 1;
    end else if (res < -(1 << N)) begin
        // Underflow, set the result to the minimum N-bit value
        res = -(1 << N);
    end
end

assign c = res;

endmodule