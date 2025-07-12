module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the signs of the input operands
    reg signed_a = a[N-1];
    reg signed_b = b[N-1];

    // Calculate the absolute values of the input operands
    reg [N-1:0] abs_a = (signed_a)? (~a + 1) : a;
    reg [N-1:0] abs_b = (signed_b)? (~b + 1) : b;

    // Perform absolute value addition or subtraction based on the signs of the input operands
    if (signed_a == signed_b) begin
        // Add the absolute values and maintain the sign consistency
        res = (signed_a)? -(abs_a + abs_b) : (abs_a + abs_b);
    end else begin
        // Perform subtraction
        if (abs_a >= abs_b) begin
            res = (abs_a - abs_b);
        end else begin
            res = -(abs_b - abs_a);
        end
    end

    // Assign the result to the output port
    c = res;
end

endmodule