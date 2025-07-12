module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
) (
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result
);

    reg signed [N-1:0] res;  // N-bit register to store the result

    always @(*) begin
        if (a[N-1] == b[N-1]) begin  // MSBs are the same
            res = a + b;  // Add absolute values and keep the same sign
        end else begin
            if (a > b) begin
                res = a - b;  // Subtract and set MSB to 0 (positive)
                if (res[N-1] == 1) begin  // Check if result is negative
                    res = -res;  // If negative, negate the result
                end
            end else begin
                res = b - a;  // Subtract and set MSB according to result
                if (res == 0) begin
                    res = 0;  // If result is zero, set MSB to 0
                end else if (res[N-1] == 1) begin  // If result is negative
                    res = -res;  // Negate the result
                end
            end
        end

        // Handle overflow
        if (res >= (1 << (N-1))) begin
            res = (1 << (N-1)) - 1;  // Saturate at maximum positive value
        end else if (res < -(1 << (N-1))) begin
            res = -(1 << (N-1));  // Saturate at minimum negative value
        end
    end

    assign c = res;  // Assign the result to output port

endmodule