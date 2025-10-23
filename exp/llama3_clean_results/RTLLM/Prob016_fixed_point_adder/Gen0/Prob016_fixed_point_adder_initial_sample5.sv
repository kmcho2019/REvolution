module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine if the MSBs of the operands are the same or different
    if (a[N-1] == b[N-1]) begin
        // If the MSBs are the same, perform absolute value addition
        res = a + b;
    end else begin
        // If the MSBs are different, perform absolute value subtraction
        if (a[N-1] == 1) begin
            // If a is negative, convert it to positive
            res = (~a + 1) - b;
        end else begin
            // If b is negative, convert it to positive
            res = a - (~b + 1);
        end
    end
    
    // Check for overflow and adjust the result if necessary
    if (res[N-1] == 1) begin
        // If the result is negative, check if it fits within the N-bit range
        if (res < -2**(N-1)) begin
            // If the result is less than the minimum N-bit value, set it to the minimum value
            res = -2**(N-1);
        end
    end else begin
        // If the result is positive, check if it fits within the N-bit range
        if (res >= 2**(N-1)) begin
            // If the result is greater than or equal to the maximum N-bit value, set it to the maximum value
            res = 2**(N-1) - 1;
        end
    end
end

assign c = res;

endmodule