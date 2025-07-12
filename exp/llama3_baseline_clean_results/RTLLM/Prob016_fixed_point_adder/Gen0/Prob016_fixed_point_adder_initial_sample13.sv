module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

always @(a, b) begin
    // Determine the signs of a and b
    reg sign_a, sign_b;
    sign_a = a[N-1];
    sign_b = b[N-1];

    // Determine the operation to perform based on the signs
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b, perform a - b
            res = a - b;
        end else begin
            // b is greater than a, perform b - a
            res = b - a;
        end
    end

    // Set the output c
    c = res;
end

endmodule