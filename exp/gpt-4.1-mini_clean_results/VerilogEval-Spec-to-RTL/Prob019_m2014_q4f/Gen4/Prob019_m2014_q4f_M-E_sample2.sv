module TopModule(
    input in1,
    input in2,
    output out
);
    wire nand_out;
    assign nand_out = ~(in1 & in2);  // NAND gate
    assign out = ~nand_out;           // inverter after NAND
endmodule