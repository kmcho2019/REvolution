module TopModule(
    input  in1,
    input  in2,
    output out
);

// Implement the required logic using a NAND gate followed by a NOT gate
wire nand_out;
assign nand_out = ~(in1 & in2);
assign out = ~nand_out;

endmodule