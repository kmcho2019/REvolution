module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If the MSBs of a and b are the same
        res = a + b;  // Add their absolute values
        if (res >= (1 << N)) begin  // Check for overflow
            res = {1'b1, {N-1{1'b1}}};  // Saturate the result
        end else if (res < 0) begin
            res = 0;  // Handle underflow
        end
    end else begin  // If the MSBs of a and b are different
        if (a[N-1] == 1'b1) begin  // If a is negative
            if (b[N-1] == 1'b0) begin  // If b is positive
                if (a > b) begin  // If a is greater than b
                    res = a - b;  // Subtract b from a
                    res[N-1] = 1'b1;  // Set the MSB of the result to 1 (negative)
                end else begin  // If b is greater than or equal to a
                    res = b - a;  // Subtract a from b
                    if (res == 0) begin
                        res[N-1] = 1'b0;  // Set the MSB of the result to 0 (positive) if result is zero
                    end else begin
                        res[N-1] = 1'b0;  // Set the MSB of the result to 0 (positive)
                    end
                end
            end
        end else begin  // If a is positive
            if (b[N-1] == 1'b1) begin  // If b is negative
                if (a > b) begin  // If a is greater than b
                    res = a - b;  // Subtract b from a
                    res[N-1] = 1'b0;  // Set the MSB of the result to 0 (positive)
                end else begin  // If b is greater than or equal to a
                    res = b - a;  // Subtract a from b
                    if (res == 0) begin
                        res[N-1] = 1'b0;  // Set the MSB of the result to 0 (positive) if result is zero
                    end else begin
                        res[N-1] = 1'b1;  // Set the MSB of the result to 1 (negative)
                    end
                end
            end
        end
    end
end

assign c = res;  // Assign the result to the output

endmodule