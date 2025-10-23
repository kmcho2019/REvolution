module comparator_3bit #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct continuous assignments using arithmetic operators
    // These outputs are mutually exclusive by definition:
    // - Only one can be true for any given input pair
    // - All false only if inputs contain X/Z (undefined)
    assign A_greater = (A > B);
    assign A_equal   = (A == B);
    assign A_less    = (A < B);

    /* Design Properties:
     * 1. Mutually Exclusive Outputs:
     *    - At most one output is high for valid inputs
     *    - All outputs low for undefined inputs (X/Z)
     * 2. Optimal PPA:
     *    - Uses built-in arithmetic comparison operators
     *    - No additional logic needed
     * 3. Scalable:
     *    - Works for any WIDTH via parameter
     */

endmodule