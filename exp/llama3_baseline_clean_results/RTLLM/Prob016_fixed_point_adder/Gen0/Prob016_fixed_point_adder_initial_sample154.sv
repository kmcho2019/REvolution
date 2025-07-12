module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the operands
    reg sign_a = a[N-1];  // Sign bit of operand a
    reg sign_b = b[N-1];  // Sign bit of operand b

    // Determine the absolute values of the operands
    reg [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;  // Absolute value of operand a
    reg [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;  // Absolute value of operand b

    // Perform addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Addition
        res = (sign_a) ? ( (~a + 1) + (~b + 1) + 1 ) : (a + b);
    end else begin
        // Subtraction
        if (abs_a > abs_b) begin
            res = (sign_a) ? ( (~a + 1) - (~b + 1) ) : (a - b);
        end else begin
            res = (sign_b) ? ( (~b + 1) - (~a + 1) ) : (b - a);
        end
    end

    // Handle overflow
    if (res[N-1] != res[N-2]) begin
        res = (res[N-1]) ? ( {1'b1, {N-1{1'b0}}} ) : ( {1'b0, {N-1{1'b1}}} );
    end

    // Assign the result to the output port
    c = res;
end

endmodule