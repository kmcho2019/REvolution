module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the signs of the input operands
    reg sign_a, sign_b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Perform absolute value addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = (sign_a) ? (-a + (-b)) : (a + b);
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            res = (sign_a) ? (-a - b) : (a - (-b));
        end else begin
            res = (sign_b) ? (-b - a) : (b - (-a));
        end
    end
end

// Output the result
assign c = res;

endmodule