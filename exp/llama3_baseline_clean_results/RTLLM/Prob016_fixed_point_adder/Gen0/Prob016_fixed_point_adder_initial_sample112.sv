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
    // Determine if both operands have the same sign (MSB)
    if (a[N-1] == b[N-1]) begin
        // Add absolute values of operands
        res = a + b;
        // Set MSB of result to match MSBs of operands (sign consistency)
        if (a[N-1] == 1'b1) begin
            // If both operands are negative, set result to negative
            res = {~res[N-1], res[N-2:0]} + 1;
        end
    end else begin
        // Determine larger absolute value
        if (a[N-1] == 1'b0) begin
            // If a is positive and b is negative, subtract b from a
            res = a - (~b + 1);
        end else begin
            // If a is negative and b is positive, subtract a from b
            res = b - (~a + 1);
        end
    end
    
    // Handle overflow by managing MSB
    if (res[N-1] != res[N-2]) begin
        // If MSB is 1 and next bit is 0, it indicates overflow
        res = {~res[N-1], res[N-2:0]} + 1;
    end
end

// Assign result to output
assign c = res;

endmodule