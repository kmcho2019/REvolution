module TopModule(
    input  a,  // Unused input, included for interface completeness
    input  b,  // Input contributing to output q
    input  c,  // Input contributing to output q
    input  d,  // Unused input, included for interface completeness
    output q   // Output high if b or c is high
);

    wire nand_out;

    // Compute NAND of b and c
    assign nand_out = ~(b & c);
    // Invert nand_out to obtain OR function (De Morgan's law)
    assign q = ~nand_out;

endmodule