module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits (integer and fractional)
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(a or b) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both a and b are positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = (2**N) - b + a;  // Two's complement addition
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both a and b are negative
        if (a <= b) begin
            res = a - b;
        end else begin
            res = (2**N) - a + b;  // Two's complement addition
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        res = a + (~b + 1);  // Add absolute values
    end else begin  // a is negative, b is positive
        res = (~a + 1) + b;  // Add absolute values
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule