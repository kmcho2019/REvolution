module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a or b) begin
    // Determine the sign of the input operands
    reg [N-1:0] abs_a, abs_b;
    reg sign_a, sign_b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Calculate absolute values
    assign abs_a = (sign_a) ? (~a + 1) : a;
    assign abs_b = (sign_b) ? (~b + 1) : b;

    if (sign_a == sign_b) begin  // Same signs, add absolute values
        res = (sign_a) ? (-(abs_a + abs_b)) : (abs_a + abs_b);
    end else begin  // Different signs, subtract absolute values
        if (abs_a >= abs_b) begin
            res = (sign_a) ? (-(abs_a - abs_b)) : (abs_a - abs_b);
        end else begin
            res = (sign_b) ? (-(abs_b - abs_a)) : (abs_b - abs_a);
        end
    end

    // Handle overflow by checking the MSB
    if (res[N-1] != sign_a && sign_a == sign_b) begin
        // Overflow occurred, set result to maximum or minimum value
        if (sign_a)
            res = {N{1'b1}};
        else
            res = {N{1'b0}};
    end
end

assign c = res;

endmodule