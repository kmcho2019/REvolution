module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits (integer + fractional)
)(
    input   [N-1:0] a,  // First fixed-point input
    input   [N-1:0] b,  // Second fixed-point input
    output  [N-1:0] c   // Result of the fixed-point subtraction
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Absolute values of the inputs (for comparison)
    reg [N-1:0] abs_a = sign_a? -a : a;
    reg [N-1:0] abs_b = sign_b? -b : b;

    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (abs_a >= abs_b) begin
            // a's sign determines the result's sign
            res = a - b;
        end else begin
            // Result will have the opposite sign of a
            res = b - a;
        end
    end

    // Handle the case where the result is zero
    if (res == 0) begin
        // Explicitly set the sign bit to 0 for a result of zero
        res[N-1] = 0;
    end

    // Assign the result to the output
    c = res;
end

endmodule