module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (must be < N)
    parameter N = 32    // Total number of bits (must be > Q)
) (
    input wire signed [N-1:0] a,  // First operand in Q.N format
    input wire signed [N-1:0] b,  // Second operand in Q.N format
    output wire signed [N-1:0] c  // Result in Q.N format (a - b)
);

    /* Fixed-Point Format: Q.N
     * - MSB (bit N-1): Sign bit
     * - Bits [N-2:Q]: Integer portion
     * - Bits [Q-1:0]: Fractional portion
     * 
     * Note: For proper operation, ensure Q < N when instantiating
     */

    // Direct subtraction handles all cases:
    // - Same sign subtraction
    // - Different sign addition
    // - Zero result (standard signed arithmetic handles sign)
    assign c = a - b;

    /* Testbench Integration:
     * Parameters are directly visible to testbench through:
     * - Hierarchical reference (instance_name.Q)
     * - Defparam override during instantiation
     * - Direct parameter passing in instantiation
     */
endmodule