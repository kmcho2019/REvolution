module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Structural implementation of AND using NAND gates
    wire nand_out;
    nand (nand_out, a, b);
    nand (y, nand_out, nand_out);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the AndGate for modularity and clarity
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule