module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First fixed-point input operand
    input [N-1:0] b,  // Second fixed-point input operand
    output [N-1:0] c  // Output representing the result of subtraction
);

reg [N-1:0] res;  // Register to store the result of subtraction

always @(*) begin
    // Check if inputs have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction: Subtract b from a
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative: Add a and the absolute value of b
            res = a + (~b + 1'b1);
        end else begin
            // a is negative, b is positive: Add the absolute value of a and b
            res = (~a + 1'b1) + b;
        end
    end

    // Handle zero result
    if (res == 0) begin
        // Explicitly set sign bit to 0 for zero result
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule