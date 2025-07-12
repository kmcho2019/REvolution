module TopModule (
    input  in1,
    input  in2,
    output out
);

wire inv_in1;
wire nand_out;
wire inv_nand_out;

not U_NOT1 (inv_in1, in1);
nand U_NAND (nand_out, inv_in1, in2);
not U_NOT2 (inv_nand_out, nand_out);

assign out = inv_nand_out;

endmodule