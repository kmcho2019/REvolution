module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_out;

    // First NAND gate: nand_out = ~(a & b)
    nand nand1 (nand_out, a, b);

    // Second NAND gate: q = ~(nand_out & nand_out) = nand_out NAND nand_out = AND(a,b)
    nand nand2 (q, nand_out, nand_out);

endmodule