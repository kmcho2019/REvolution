module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
)(
    input   signed [N-1:0] a,  // First N-bit fixed-point input operand
    input   signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output  signed [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg signed [N-1:0] res;  // N-bit register to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If MSBs of a and b are the same
        res = a + b;  // Add absolute values
    end else begin  // If MSBs of a and b are different
        if (a >= b) begin  // If a is greater than b
            res = a - b;  // Result is a - b, and MSB is 0 (positive)
        end else begin  // If b is greater than a
            res = b - a;  // Result is b - a, and MSB is set according to the result
        end
    end
end

assign c = res;  // Assign result to output port c

endmodule