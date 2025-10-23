module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the operation based on the most significant bits (MSBs) of the input operands
    if (a[N-1] == b[N-1]) begin
        // Absolute Value Addition: add the absolute values of a and b
        res = (a[N-1] == 1'b0)? (a + b) : ( (~a + 1) + (~b + 1) );
    end else begin
        // Absolute Value Subtraction: subtract the smaller absolute value from the larger
        if ( (a[N-1] == 1'b0 && b[N-1] == 1'b1) || ((~a + 1) < (~b + 1)) ) begin
            // If a is greater than b or if a is positive and b is negative, result is a - b
            res = (a[N-1] == 1'b0)? (a - (~b + 1)) : ( (~a + 1) - b );
        end else begin
            // If b is greater than a or if b is positive and a is negative, result is b - a
            res = (b[N-1] == 1'b0)? (b - (~a + 1)) : ( (~b + 1) - a );
        end
    end
    
    // Ensure the result fits within the N-bit range
    if (res[N-1]!= res[N-2]) begin
        // Overflow detected, adjust the result
        if (res[N-1] == 1'b1) begin
            // Negative overflow
            res = {1'b1, {N-1{1'b1}}};
        end else begin
            // Positive overflow
            res = {1'b0, {N-1{1'b1}}};
        end
    end
    
    // Assign the result to the output port
    c = res;
end

endmodule