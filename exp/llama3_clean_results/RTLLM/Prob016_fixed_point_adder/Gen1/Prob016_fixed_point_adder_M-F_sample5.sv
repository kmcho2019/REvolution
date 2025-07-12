module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of input operands
    if (a[N-1] == b[N-1]) begin // Same sign
        // Perform absolute value addition
        res = a + b;
    end else begin // Different signs
        // Perform absolute value subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Set the MSB of the result to match the MSBs of a and b
    if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        c = {1'b1, res[N-2:0]};
    end else begin
        c = {1'b0, res[N-2:0]};
    end
    
    // Handle overflow by checking the MSB
    if (res[N] == 1'b1) begin
        // Overflow occurred, adjust the result
        if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
            c = {1'b1, {N-1{1'b1}}};
        end else begin
            c = {1'b0, {N-1{1'b0}}};
        end
    end else begin
        c = res;
    end
end

endmodule