module NANDGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = ~(a & b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_out;

    // First NAND gate: NAND(a, b)
    NANDGate nand1 (
        .a(a),
        .b(b),
        .y(nand_out)
    );

    // Second NAND gate: NAND(nand_out, nand_out) = AND(a, b)
    NANDGate nand2 (
        .a(nand_out),
        .b(nand_out),
        .y(q)
    );
endmodule