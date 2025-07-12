module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute OR of inputs a and b
    wire a_or_b = a | b;

    // Compute OR of inputs c and d
    wire c_or_d = c | d;

    // Output q is high only if (a or b) AND (c or d) are high
    assign q = a_or_b & c_or_d;

endmodule