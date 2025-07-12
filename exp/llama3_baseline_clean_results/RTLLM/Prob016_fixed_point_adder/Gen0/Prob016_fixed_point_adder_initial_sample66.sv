module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)
(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg signed [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If the MSBs of a and b are the same
        res = a + b;  // Add the absolute values of a and b
    end else begin  // If the MSBs of a and b are different
        if (a >= b) begin  // If a is greater than or equal to b
            res = a - b;  // Subtract b from a
        end else begin  // If b is greater than a
            res = b - a;  // Subtract a from b
        end
    end

    // Handle overflow
    if (res > {1'b1, {N-1{1'b0}}}) begin  // If the result exceeds the maximum value that can be represented by N bits
        res = {1'b1, {N-1{1'b0}}};  // Set the MSB to 1 (indicating a negative result) and take the two's complement of the result
    end else if (res < {{N-1{1'b1}}, 1'b0}) begin  // If the result is less than the minimum value that can be represented by N bits
        res = {{N-1{1'b1}}, 1'b0};  // Set the MSB to 1 (indicating a negative result) and take the two's complement of the result
    end

    c = res;  // Assign the result to the output port
end

endmodule