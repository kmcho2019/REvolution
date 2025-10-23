module TopModule(
    input in1,
    input in2,
    output out
);
    nand u_nand(out, in1, in2);
endmodule