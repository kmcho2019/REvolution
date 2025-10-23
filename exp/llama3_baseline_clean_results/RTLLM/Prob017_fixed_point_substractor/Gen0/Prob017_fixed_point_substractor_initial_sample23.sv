module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the sign of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        // Perform subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b1;  // Set sign bit to 1 (negative)
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        // Perform subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b0;  // Set sign bit to 0 (positive)
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        // Perform addition
        res = a + (~b + 1'b1);  // Two's complement of b
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a negative, b positive
        // Perform addition
        res = (~a + 1'b1) + b;  // Two's complement of a
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set sign bit to 0
    end
end

assign c = res;

endmodule