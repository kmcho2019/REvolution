module fixed_point_adder #(
    parameter Q = 4,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

always @(*) begin
    // Determine the sign bits of a and b
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Compare the signs to decide the operation
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = (a[N-1] ? -a : a) + (b[N-1] ? -b : b);
        // Set the MSB of the result to match the MSBs of a and b
        if (sign_a) begin
            // Negative result
            if (res[N-1] == 0) begin
                // If result is positive, convert it to negative
                res = -res;
            end
        end else begin
            // Positive result, ensure MSB is 0
            res[N-1] = 0;
        end
    end else begin
        // Absolute value subtraction
        if ((a[N-1] ? -a : a) > (b[N-1] ? -b : b)) begin
            // a is greater than b, result is a - b
            res = (a[N-1] ? -a : a) - (b[N-1] ? -b : b);
            // Result is positive, ensure MSB is 0
            res[N-1] = 0;
        end else begin
            // b is greater than a, result is b - a
            res = (b[N-1] ? -b : b) - (a[N-1] ? -a : a);
            // Check if result is negative and set MSB accordingly
            if (res[N-1] == 0 && res != 0) begin
                // Result is positive but should be negative, convert it
                res = -res;
            end
        end
    end

    // Assign the result to output c, considering overflow
    if (res[N-1] && res != 0) begin
        // Negative overflow, saturate at minimum value
        c = {1, {N-1{1'b1}}};
    end else if (!res[N-1] && res != 0) begin
        // Positive overflow, saturate at maximum value
        c = {1'b0, {N-1{1'b1}}};
    end else begin
        // No overflow, assign result directly
        c = res;
    end
end

endmodule