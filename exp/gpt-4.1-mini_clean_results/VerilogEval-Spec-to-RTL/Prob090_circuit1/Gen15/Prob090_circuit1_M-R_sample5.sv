module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_out;

    // First NAND operation: NAND(a, b)
    assign nand_out = ~(a & b);

    // Second NAND operation: NAND(nand_out, nand_out) = AND(a, b)
    assign q = ~(nand_out & nand_out);

endmodule