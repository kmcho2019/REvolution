module TopModule (
    input x,
    input y,
    output z
);
    wire nand_xy, nor_xy;
    
    assign nand_xy = ~(x & y);
    assign nor_xy = ~(x | y);
    assign z = ~(nand_xy | nor_xy);
endmodule