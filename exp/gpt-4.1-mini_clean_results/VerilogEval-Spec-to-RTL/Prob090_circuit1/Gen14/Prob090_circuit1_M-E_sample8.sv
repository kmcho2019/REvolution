module NandGate (
    input  wire a,
    input  wire b,
    output wire y
);
    nand (y, a, b);
endmodule

module NotGate (
    input  wire a,
    output wire y
);
    not (y, a);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_out;

    // Instantiate NAND gate
    NandGate nand_inst (
        .a(a),
        .b(b),
        .y(nand_out)
    );

    // Instantiate NOT gate to invert NAND output => AND function
    NotGate not_inst (
        .a(nand_out),
        .y(q)
    );
endmodule