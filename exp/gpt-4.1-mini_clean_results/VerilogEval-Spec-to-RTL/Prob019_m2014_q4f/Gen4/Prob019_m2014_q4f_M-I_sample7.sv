module TopModule (
    input  in1,
    input  in2,
    output out
);

// NAND gate implements AND with bubble on in2 input:
// AND(in1, ~in2) = NAND(in1, in2)
nand u_nand(out, in1, in2);

endmodule