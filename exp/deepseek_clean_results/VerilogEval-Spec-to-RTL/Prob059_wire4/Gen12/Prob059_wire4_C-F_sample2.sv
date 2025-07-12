/*
 * TopModule - Simple wire connection module
 * Maps inputs to outputs as follows:
 *   a -> w
 *   b -> x, y (duplicated)
 *   c -> z
 */
module TopModule (
    // Input ports
    input  a,    // Input signal a
    input  b,    // Input signal b (drives both x and y)
    input  c,    // Input signal c
    
    // Output ports
    output w,    // Output w = a
    output x,    // Output x = b
    output y,    // Output y = b
    output z     // Output z = c
);

    // Efficient single assignment using concatenation
    assign {w, x, y, z} = {a, b, b, c};

endmodule