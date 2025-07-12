module TopModule (
    input  a,    // First control input
    input  b,    // Second control input
    input  c,    // First data input
    input  d,    // Second data input
    output q     // Output result
);

    // Intermediate signals (explicit for clarity, will be optimized)
    wire a_or_b;
    wire c_or_d;

    // First level OR operations
    assign a_or_b = (a | b);
    assign c_or_d = (c | d);

    // Final AND operation
    assign q = (a_or_b & c_or_d);

endmodule