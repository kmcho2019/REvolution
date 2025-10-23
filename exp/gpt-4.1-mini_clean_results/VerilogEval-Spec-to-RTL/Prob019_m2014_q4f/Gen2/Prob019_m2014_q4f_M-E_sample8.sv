module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in1_inv, nand_out;

assign in1_inv = ~in1;
assign nand_out = ~(in1_inv & in2);
assign out = nand_out;

endmodule