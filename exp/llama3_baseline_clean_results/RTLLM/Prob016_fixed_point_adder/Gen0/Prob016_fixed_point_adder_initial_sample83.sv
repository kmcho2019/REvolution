module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check if the most significant bits (MSBs) of `a` and `b` are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // Ensure the sign bit of the result matches the sign bits of `a` and `b`
        if (a[N-1] == 1'b1) begin
            // If both are negative, make sure the result's MSB is set
            if (res[N-1] == 1'b0) begin
                // Handle overflow by flipping the bits and adding 1 (2's complement)
                res = ~(res - 1) + 1;
            end
        end else begin
            // If both are positive, ensure the MSB of the result is cleared
            if (res[N-1] == 1'b1) begin
                // Handle overflow by flipping the bits and adding 1 (2's complement)
                res = ~(res - 1) + 1;
            end
        end
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            // If `a` is greater than `b`, the result is `a - b` and the MSB of the result is set to 0 (positive)
            res = a - b;
        end else begin
            // If `b` is greater than `a`, the result is `b - a`
            res = b - a;
        end
        
        // Ensure the sign bit of the result is correct
        if (res == 0) begin
            // If the result is zero, clear the MSB
            res[N-1] = 1'b0;
        end else if (res[N-1] == 1'b0) begin
            // If the result is negative, set the MSB
            res = ~(res - 1) + 1;
        end
    end
    
    // Assign the result to the output port `c`
    c = res;
end

endmodule