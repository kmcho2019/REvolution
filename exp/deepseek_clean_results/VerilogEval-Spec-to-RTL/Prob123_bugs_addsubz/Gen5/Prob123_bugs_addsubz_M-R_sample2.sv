module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Adder/subtractor operation using ternary operator
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag generation
    assign result_is_zero = (out == 8'b0);

    /* Potential Optimizations:
     * 1. For synchronous systems: Consider clock gating the adder/subtractor
     * 2. For area reduction: Explore resource sharing between adder/subtractor
     * 3. For power: Register the zero flag if timing allows
     */

endmodule