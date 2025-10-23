module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Implement XNOR(in1, in2) using NAND gates
    wire nand1, nand2, nand3, nand4;
    nand(nand1, in1, in2);
    nand(nand2, in1, nand1);
    nand(nand3, in2, nand1);
    nand(nand4, nand2, nand3);  // This is XNOR(in1, in2)

    // Implement XOR(nand4, in3) using NAND gates
    wire nand5, nand6, nand7;
    nand(nand5, nand4, in3);
    nand(nand6, nand4, nand5);
    nand(nand7, in3, nand5);
    nand(out, nand6, nand7);    // This is XOR(nand4, in3)

endmodule