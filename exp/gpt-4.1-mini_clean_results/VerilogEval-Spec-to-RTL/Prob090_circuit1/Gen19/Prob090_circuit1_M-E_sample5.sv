module NandGate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = ~(a & b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_ab;

    // First NAND gate: output is NAND of inputs
    NandGate nand1 (
        .a(a),
        .b(b),
        .y(nand_ab)
    );

    // Second NAND gate: inverter of nand_ab to get AND output
    NandGate nand2 (
        .a(nand_ab),
        .b(nand_ab),
        .y(q)
    );
endmodule