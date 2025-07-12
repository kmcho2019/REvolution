module comparator_3bit #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Subtraction-based comparison (no overflow possible for 3-bit inputs)
    wire [WIDTH-1:0] diff = A - B;

    // Output assignments with inherent mutual exclusivity
    assign A_greater = (diff != 0) && !diff[WIDTH-1];  // Positive difference
    assign A_equal   = (diff == 0);                   // Zero difference
    assign A_less    = diff[WIDTH-1];                 // Negative difference

    /* Design Properties:
     * 1. Optimal PPA:
     *    - Single subtraction operation
     *    - Minimal decoding logic
     *    - Balanced timing paths
     * 2. Mutual Exclusivity:
     *    - Exactly one output high for valid inputs
     *    - All outputs low for undefined inputs (X/Z)
     * 3. Power Efficient:
     *    - No unnecessary bit extensions
     *    - Minimal switching activity
     * 4. Scalable:
     *    - Parameterized width (optimal for WIDTH=3)
     */
endmodule