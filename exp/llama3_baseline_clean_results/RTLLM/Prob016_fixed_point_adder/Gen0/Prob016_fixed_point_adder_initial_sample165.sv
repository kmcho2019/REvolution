module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // N-bit register to store the result

always @(*) begin
    // Determine the sign of the input operands
    reg sign_a = a[N-1];  // Sign bit of operand a
    reg sign_b = b[N-1];  // Sign bit of operand b

    // Absolute Value Addition
    if (sign_a == sign_b) begin
        // Add the absolute values and set the sign bit
        res = (sign_a)? (a + b) : (a + b);
    end else begin
        // Absolute Value Subtraction
        if ((~sign_a && sign_b) || (a > b)) begin
            // Result is a - b
            res = a - b;
        end else begin
            // Result is b - a
            res = b - a;
        end
    end
    
    // Apply saturation for overflow handling
    if (res[N-1]!= res[N-2]) begin  // Check if MSB and next bit differ
        if (res[N-1]) begin  // Overflow to negative, saturate to minimum value
            res = {1, {N-1{1}}};
        end else begin  // Overflow to positive, saturate to maximum value
            res = {1, {N-1{0}}};
        end
    end

    // Assign result to output
    c = res;
end

endmodule