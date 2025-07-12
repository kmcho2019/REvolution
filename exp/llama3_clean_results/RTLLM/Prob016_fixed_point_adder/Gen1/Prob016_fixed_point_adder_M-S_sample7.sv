module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        // Perform absolute value addition
        c = a + b;
    end else begin // Different signs
        // Perform absolute value subtraction
        if (a >= b) begin
            c = a - b;
        end else begin
            c = b - a;
        end
    end
end

endmodule