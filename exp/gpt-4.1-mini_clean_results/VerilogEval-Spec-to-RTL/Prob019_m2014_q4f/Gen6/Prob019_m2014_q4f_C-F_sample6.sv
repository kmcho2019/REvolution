module TopModule(
    input in1,
    input in2,
    output out
);
    wire inv_in1;
    not u_not(inv_in1, in1);
    nand u_nand(out, inv_in1, in2);
endmodule