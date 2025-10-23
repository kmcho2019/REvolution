module TopModule (input a, b, c, d, output q);
    wire nor_bc;
    wire nand_bc;
    
    assign nor_bc = ~(b | c);
    assign nand_bc = ~(b & c);
    
    assign q = ~(nor_bc & nand_bc);
endmodule