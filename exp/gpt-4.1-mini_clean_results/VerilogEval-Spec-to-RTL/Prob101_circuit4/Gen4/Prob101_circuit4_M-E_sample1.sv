module TopModule(
    input  a,  // Unused input, present per specification
    input  b,  // Input contributing to output q
    input  c,  // Input contributing to output q
    input  d,  // Unused input, present per specification
    output q   // Output: q = b | c, implemented via NAND gates
);

    // Intermediate wires for inverted inputs
    wire nb, nc;
    wire nand_out;

    // Invert inputs b and c
    assign nb = ~b;
    assign nc = ~c;

    // NAND of inverted inputs: nand_out = ~(nb & nc)
    assign nand_out = ~(nb & nc);

    // Assign output q to nand_out (equivalent to b | c)
    assign q = nand_out;

endmodule