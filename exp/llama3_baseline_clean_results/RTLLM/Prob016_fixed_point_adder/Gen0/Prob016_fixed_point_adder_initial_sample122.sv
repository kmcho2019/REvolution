module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the signs of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Check if signs are the same (both positive or both negative)
    if (sign_a == sign_b) begin
        // Add absolute values
        res = (sign_a) ? -(~a + 1) + -(~b + 1) : a + b;
    end else begin
        // Determine the larger absolute value
        wire [N-1:0] abs_a = (sign_a) ? -(~a + 1) : a;
        wire [N-1:0] abs_b = (sign_b) ? -(~b + 1) : b;

        if (abs_a >= abs_b) begin
            // Result is a - b
            res = (sign_a) ? -(~a + 1) - -(~b + 1) : a - b;
        end else begin
            // Result is b - a
            res = (sign_b) ? -(~b + 1) - -(~a + 1) : b - a;
        end
    end

    // Ensure result fits within N-bit range
    if (res[N-1] != res[N-2]) begin
        // Overflow or underflow, set result to max or min value accordingly
        res = (res[N-1]) ? {N{1'b1}} : {N{1'b0}};
    end
end

assign c = res;

endmodule