module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  logic [N-1:0] a,  // First N-bit fixed-point input operand
    input  logic [N-1:0] b,  // Second N-bit fixed-point input operand
    output logic [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

logic [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always_comb begin
    // Determine the signs of the inputs
    logic sign_a = a[N-1];
    logic sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the inputs
        res = a - b;

        // If the result is zero, explicitly set the sign bit to 0
        if (res == 0) begin
            res = 0;
        end else begin
            // The sign of the result is the same as the inputs
            res[N-1] = sign_a;
        end
    end
    // Different sign subtraction
    else begin
        // Add the absolute values of the inputs
        res = (sign_a ? -a : a) + (sign_b ? -b : b);

        // Determine the sign of the result based on the relative sizes of the inputs
        if (a >= b) begin
            res[N-1] = 0;  // Positive sign
        end else begin
            res[N-1] = 1;  // Negative sign
        end

        // If the result is zero, explicitly set the sign bit to 0
        if (res == 0) begin
            res = 0;
        end
    end
end

assign c = res;

endmodule