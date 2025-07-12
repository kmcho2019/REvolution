module TopModule(
    input a,
    input b,
    input c,
    output out
);
    wire nand_bc;
    wire nand_abc;
    
    assign nand_bc = ~(b & c);
    assign nand_abc = ~(a & nand_bc);
    assign out = ~nand_abc;  // This is equivalent to a | b | c
endmodule