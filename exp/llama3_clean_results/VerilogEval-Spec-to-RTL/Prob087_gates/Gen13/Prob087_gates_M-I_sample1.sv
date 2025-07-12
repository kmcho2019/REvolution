// Integrated module for all gates
module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Direct implementation of logic gates
    assign out_and = a && b;
    assign out_or = a || b;
    assign out_xor = a ^ b;
    assign out_nand = ~(a && b); // Compute NAND by inverting AND
    assign out_nor = ~(a || b); // Compute NOR by inverting OR
    assign out_xnor = ~(a ^ b); // Compute XNOR by inverting XOR
    assign out_anotb = a && ~b; // AND with inverted B

endmodule