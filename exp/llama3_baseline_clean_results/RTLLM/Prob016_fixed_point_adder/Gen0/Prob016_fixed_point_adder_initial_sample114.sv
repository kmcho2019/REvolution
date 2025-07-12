module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result
);

reg signed [N-1:0] res;  // Internal register for result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, perform addition
        res = a + b;
        // Check for overflow and adjust if necessary
        if ((res >= (1 << (N-1))) || (res < -(1 << (N-1)))) begin
            if (res > 0) begin
                res = (1 << (N-1)) - 1;
            end else begin
                res = -(1 << (N-1));
            end
        end
    end else begin  // Different signs, perform subtraction
        if (a > b) begin  // a is greater, perform a - b
            res = a - b;
        end else begin  // b is greater, perform b - a
            res = b - a;
        end
        // Adjust MSB if result is negative and inputs had different signs
        if (res < 0 && a[N-1] == 1'b0) begin
            res = -res;
        end
    end
    c = res;  // Assign result to output
end

endmodule