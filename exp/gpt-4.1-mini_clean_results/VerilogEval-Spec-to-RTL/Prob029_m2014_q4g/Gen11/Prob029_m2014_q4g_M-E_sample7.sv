module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire n1, n2, n3, xnor_out, n4, n5, n6;

    // XNOR using NAND gates:
    // xnor = ~(in1 ^ in2) = (in1 NAND in1) NAND (in2 NAND in2) NAND (in1 NAND in2)
    nand (n1, in1, in1);
    nand (n2, in2, in2);
    nand (n3, in1, in2);
    nand (xnor_out, n1, n2, n3); // 3-input NAND

    // XOR with in3 using NAND gates:
    // xor = (a NAND b) NAND ( (a NAND (a NAND b)) NAND (b NAND (a NAND b)) )
    // Here a = xnor_out, b = in3
    nand (n4, xnor_out, in3);
    nand (n5, xnor_out, n4);
    nand (n6, in3, n4);
    nand (out, n5, n6);

endmodule