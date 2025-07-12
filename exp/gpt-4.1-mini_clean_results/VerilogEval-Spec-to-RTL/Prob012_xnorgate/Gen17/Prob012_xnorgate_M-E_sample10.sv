module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

    wire nand_ab;
    wire nand_a_nandab;
    wire nand_b_nandab;
    wire xor_out;

    // Build XOR from NAND gates:
    // XOR = (a & ~b) | (~a & b)
    // Using NAND gates only:
    assign nand_ab = ~(a & b);
    assign nand_a_nandab = ~(a & nand_ab);
    assign nand_b_nandab = ~(b & nand_ab);
    assign xor_out = ~(nand_a_nandab & nand_b_nandab);

    // XNOR is inversion of XOR
    assign out = ~xor_out;

endmodule