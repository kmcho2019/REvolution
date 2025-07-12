module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32   // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output wire signed [N-1:0] c  // Fixed-point result (Q.N format)
);

    // Parameter validation with improved error message
    generate
        if (Q >= N) begin
            initial begin
                $error("FixedPointSubtractor: Invalid parameters - Q (%0d) must be less than N (%0d)", Q, N);
                $finish;
            end
        end
    endgenerate

    // Core subtraction operation (handles both same and different signs)
    wire signed [N-1:0] raw_result = a - b;

    // Zero detection and handling:
    // - OR reduction checks all bits except sign bit (N-2:0)
    // - If all zero, force sign bit to 0
    // - Otherwise pass through raw result
    assign c = (|raw_result[N-2:0]) ? raw_result : {1'b0, {N-1{1'b0}}};

    // Note: This implementation properly handles:
    // 1. Same sign subtraction
    // 2. Different sign subtraction (effectively becomes addition)
    // 3. Zero result with positive sign
    // 4. Fixed-point precision maintained via Q.N format

endmodule