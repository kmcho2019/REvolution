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
        // Set the MSB of the result to match the MSBs of a and b
        c = {res[N-1], res[N-2:0]};
    end else begin // Different signs
        // Perform absolute value subtraction
        if (a >= b) begin
            res = a - b;
            // Set the MSB of the result to 0 (positive)
            c = {1'b0, res[N-2:0]};
        end else begin
            res = b - a;
            // Set the MSB of the result according to whether the result is zero or negative
            if (res == 0) begin
                c = {1'b0, res[N-2:0]};
            end else begin
                c = {1'b1, res[N-2:0]};
            end
        end
    end
    
    // Handle overflow by checking the MSB
    if (c[N-1] != a[N-1] && c[N-1] != b[N-1]) begin
        // Overflow occurred, adjust the MSB
        c = {a[N-1], c[N-2:0]};
    end
end

endmodule