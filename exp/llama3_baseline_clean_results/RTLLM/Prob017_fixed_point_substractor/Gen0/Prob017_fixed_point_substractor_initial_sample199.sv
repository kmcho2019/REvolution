module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Check if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction: subtract the absolute values of a and b
        res = a - b;
    end else begin
        // Different sign subtraction: add the absolute values of a and b
        if (a[N-1] == 1) begin
            // a is negative, b is positive
            res = (a + (1 << N) - b);
        end else begin
            // a is positive, b is negative
            res = (a + (1 << N) - b);
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;  // Explicitly set the sign bit to 0
    end

    c = res;  // Assign the result to the output port
end

endmodule