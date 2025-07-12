module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  reg  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Determine the absolute values of the operands
    reg [N-1:0] abs_a = sign_a? (~a + 1) : a;
    reg [N-1:0] abs_b = sign_b? (~b + 1) : b;

    // Perform absolute value addition or subtraction
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = (sign_a? (~a + 1) : a) + (sign_b? (~b + 1) : b);
        // Set the sign bit of the result to match the sign of the operands
        if (res[N-1]) begin
            // If the result is negative, convert it to two's complement form
            res = ~res + 1;
        end
        res[N-1] = sign_a;
    end else begin
        // Absolute value subtraction
        if (abs_a > abs_b) begin
            // a is greater than b, perform a - b
            res = a - b;
            // Set the sign bit of the result to 0 (positive)
            res[N-1] = 0;
        end else begin
            // b is greater than a, perform b - a
            res = b - a;
            // Set the sign bit of the result according to whether the result is zero or negative
            if (res == 0) begin
                res[N-1] = 0;
            end else begin
                res[N-1] = 1;
            end
        end
    end

    // Assign the result to the output port
    c = res;
end

endmodule