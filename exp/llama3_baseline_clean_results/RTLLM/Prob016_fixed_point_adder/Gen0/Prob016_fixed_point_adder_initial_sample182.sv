module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits
)(
    input  wire [N-1:0] a, // First N-bit fixed-point input operand
    input  wire [N-1:0] b, // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the operands
    reg sign_a = a[N-1]; // Sign bit of operand a
    reg sign_b = b[N-1]; // Sign bit of operand b

    // Perform absolute value addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Both operands have the same sign, perform addition
        res = a + b;
    end else begin
        // Operands have different signs, perform subtraction
        if (a > b) begin
            // a is greater, perform a - b
            res = a - b;
        end else begin
            // b is greater, perform b - a
            res = b - a;
        end
    end

    // Assign the result to the output, managing the sign
    c = res;
end

endmodule