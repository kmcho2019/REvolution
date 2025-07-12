module TopModule (
    input  a,    // First enable input
    input  b,    // Second enable input
    input  c,    // First data condition
    input  d,    // Second data condition
    output q     // Output result
);

    // The output is active when:
    // 1. At least one enable (a or b) is active, AND
    // 2. At least one data condition (c or d) is met
    assign q = (a | b) & (c | d);

endmodule