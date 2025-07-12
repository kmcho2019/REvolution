module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Both operands have the same sign
        // Perform addition
        res = a + b;
        
        // Manage overflow by checking the most significant bit
        if (res[N] == 1'b1) begin
            // If overflow, adjust the result to fit within N bits
            res = {1'b0, res[N-1:1]};
        end
    end else begin  // Operands have different signs
        // Determine the larger absolute value
        if (a > b) begin
            // a is larger, perform a - b and set MSB to 0 (positive)
            res = a - b;
            // Since a is larger and result will be positive, no need to check MSB
        end else begin
            // b is larger, perform b - a and set MSB according to result
            res = b - a;
            // No explicit MSB setting needed as the result of subtraction will handle it
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule