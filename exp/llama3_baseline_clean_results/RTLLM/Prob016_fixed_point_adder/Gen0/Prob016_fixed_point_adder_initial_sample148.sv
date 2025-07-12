module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a, // First fixed-point operand
    input [N-1:0] b, // Second fixed-point operand
    output [N-1:0] c  // Result of the fixed-point addition
);

reg [N-1:0] res; // Register to store the result

// Perform the addition or subtraction based on the signs of the input operands
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Signs are the same
        // Add the absolute values
        res = a + b;
    end else begin // Signs are different
        if (a[N-1] == 1) begin // a is negative
            // Convert a to positive (2's complement), then subtract b
            if (a < b) begin
                res = ~a + 1 - b; // Subtract b from the 2's complement of a
                if (res[N-1] == 1) begin // Result is negative
                    res = {1'b0, N-1'b0}; // Handle underflow
                end else begin
                    res = {1'b0, res[N-2:0]}; // Set sign bit to 0 (positive)
                end
            end else begin
                res = a - b; // a is larger, subtract b from a
                res = {1'b1, res[N-2:0]}; // Set sign bit to 1 (negative)
            end
        end else begin // b is negative
            // Convert b to positive (2's complement), then subtract b from a
            if (a < b) begin
                res = a - (~b + 1); // Subtract 2's complement of b from a
                if (res[N-1] == 1) begin // Result is negative
                    res = {1'b0, N-1'b0}; // Handle underflow
                end else begin
                    res = {1'b0, res[N-2:0]}; // Set sign bit to 0 (positive)
                end
            end else begin
                res = a - b; // a is larger, subtract b from a
                res = {1'b0, res[N-2:0]}; // Set sign bit to 0 (positive)
            end
        end
    end
    // Check for overflow and handle it
    if (res >= (1 << (N-1))) begin
        res = {1'b1, N-1'b1}; // Overflow, set to max negative value
    end else if (res < -(1 << (N-1))) begin
        res = {1'b0, N-1'b1}; // Underflow, set to max positive value
    end
    c = res; // Assign the result to the output
end

endmodule