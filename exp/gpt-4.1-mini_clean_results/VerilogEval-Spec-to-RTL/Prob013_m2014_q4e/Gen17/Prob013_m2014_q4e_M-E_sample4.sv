module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    wire nand1_out, nand2_out;

    nand nand1 (nand1_out, in1, in1); // NAND(a,a) = NOT a
    nand nand2 (nand2_out, in2, in2); // NAND(b,b) = NOT b
    nand nand3 (out, nand1_out, nand2_out); // NAND of inverted inputs = NOR

endmodule