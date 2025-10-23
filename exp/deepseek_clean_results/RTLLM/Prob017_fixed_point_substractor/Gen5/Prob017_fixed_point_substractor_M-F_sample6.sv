module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32    // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output wire signed [N-1:0] c  // Fixed-point result (Q.N format)
);

    // Parameter validation with more descriptive error
    generate
        if (Q >= N) begin
            initial begin
                $error("FixedPointSubtractor: Invalid parameters - Fractional bits Q(%0d) must be < Total bits N(%0d)", Q, N);
                $finish;
            end
        end
    endgenerate

    // Define sign bit position for clarity
    localparam SIGN_BIT = N-1;

    // Main subtraction operation
    wire signed [N-1:0] raw_result = a - b;

    // Optimized zero detection and handling
    assign c = (raw_result == 0) ? {1'b0, {N-1{1'b0}}} : raw_result;

    // Documentation for testbench integration
    /* Testbench Note:
     * To access parameters in testbench:
     * - Use hierarchical reference: tb.uut.Q
     * - Or define identical parameters in testbench
     * - Or use `defparam` to override during instantiation
     */

endmodule