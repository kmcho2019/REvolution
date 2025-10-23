module comparator_3bit #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct arithmetic comparisons for optimal PPA
    // These assignments are mutually exclusive by construction
    assign A_greater = (A > B);
    assign A_equal   = (A == B);
    assign A_less    = (A < B);

    /* Synthesis Notes:
     * 1. Using direct comparison operators allows synthesis tools to select
     *    optimal implementation (carry-chain for FPGAs, custom cells for ASICs)
     * 2. Outputs are guaranteed mutually exclusive (only one can be high)
     * 3. Parameterized for potential future width extension
     */

endmodule