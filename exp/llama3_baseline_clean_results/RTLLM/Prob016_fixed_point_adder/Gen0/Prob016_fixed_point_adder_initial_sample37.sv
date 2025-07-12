module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // N-bit register to store the result

always @(a, b) begin
    // Determine the sign of the operands
    reg sign_a, sign_b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Calculate the absolute values of the operands
    reg [N-1:0] abs_a, abs_b;
    assign abs_a = (sign_a) ? (~a + 1) : a;
    assign abs_b = (sign_b) ? (~b + 1) : b;

    // Perform addition or subtraction based on the signs of the operands
    if (sign_a == sign_b) begin
        // If both operands have the same sign, add their absolute values
        // and maintain the sign consistency
        res = (sign_a) ? (abs_a + abs_b)[N-1:0] : (abs_a + abs_b)[N-1:0];
    end else begin
        // If the operands have different signs, perform subtraction
        if (abs_a > abs_b) begin
            // If a is greater than b, subtract b from a and set the result's sign to positive
            res = (abs_a - abs_b)[N-1:0];
        end else begin
            // If b is greater than a, subtract a from b and set the result's sign accordingly
            res = (~abs_b + abs_a + 1)[N-1:0];
            if (res == 0) begin
                res = 0;
            end else begin
                res = (~res + 1)[N-1:0];
            end
        end
    end
end

assign c = res;

endmodule