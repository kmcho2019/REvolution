module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] abs_a, abs_b; // Absolute values of input operands
reg sign_a, sign_b; // Signs of input operands

always @(*) begin
    sign_a = a[N-1];
    sign_b = b[N-1];
    abs_a = (sign_a == 1'b0)? a : ~a + 1'b1;
    abs_b = (sign_b == 1'b0)? b : ~b + 1'b1;

    if (sign_a == sign_b) begin // Same sign
        c = (sign_a == 1'b1)? ~(abs_a + abs_b) + 1'b1 : abs_a + abs_b;
    end else begin // Different signs
        if (abs_a >= abs_b) begin
            c = (sign_a == 1'b1)? ~(abs_a - abs_b) + 1'b1 : abs_a - abs_b;
        end else begin
            c = (sign_b == 1'b1)? ~(abs_b - abs_a) + 1'b1 : abs_b - abs_a;
        end
    end

    // Overflow handling
    if (c[N-1] != sign_a && c != 0) begin
        c = (sign_a == 1'b1)? {1'b1, {N-1{1'b0}}} : {1'b0, {N-1{1'b1}}};
    end
end

endmodule