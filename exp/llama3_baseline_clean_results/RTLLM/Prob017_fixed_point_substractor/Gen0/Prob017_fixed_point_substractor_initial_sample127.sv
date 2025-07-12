module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        // Same sign subtraction: both positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = (1 << N) - b + a;
            res[N-1] = 1'b1;  // Set the sign bit
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        // Same sign subtraction: both negative
        if (a >= b) begin
            res = a - b;
        end else begin
            res = (1 << N) - b + a;
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
        // Different sign subtraction: a is positive, b is negative
        if (a >= ~b + 1) begin
            res = a + ~b + 1;
        end else begin
            res = (1 << N) - (~b + 1) + a;
            res[N-1] = 1'b1;  // Set the sign bit
        end
    end else begin
        // Different sign subtraction: a is negative, b is positive
        if (~a + 1 >= b) begin
            res = ~a + 1 + ~b;
            res[N-1] = 1'b1;  // Set the sign bit
        end else begin
            res = (1 << N) - b + (~a + 1);
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0
    end

    c = res;  // Assign the result to the output
end

endmodule