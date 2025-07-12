/*
 * TopModule - Simple wire mapping module
 * Maps inputs to outputs as follows:
 *   a -> w
 *   b -> x
 *   b -> y
 *   c -> z
 */
module TopModule (
    input  a,    // Input signal a
    input  b,    // Input signal b
    input  c,    // Input signal c
    output w,    // Output w (connected to input a)
    output x,    // Output x (connected to input b)
    output y,    // Output y (connected to input b)
    output z     // Output z (connected to input c)
);

    // Direct wire connections using concatenation
    // This implementation is optimal for PPA:
    // - No logic gates (minimal area)
    // - Zero delay paths (perfect timing)
    // - Minimal power consumption
    assign {w, x, y, z} = {a, b, b, c};

endmodule