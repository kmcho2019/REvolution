module TopModule(
    input in1,
    input in2,
    output out
);
    wire nand_out;
    nand u_nand(nand_out, in1, in2);
    not u_not(out, nand_out);
endmodule