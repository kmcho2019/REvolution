module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire a_nand, b_nand, c_nand;
    wire combined_nand;
    
    assign a_nand = ~(a & a);
    assign b_nand = ~(b & b);
    assign c_nand = ~(c & c);
    assign combined_nand = ~(a_nand & b_nand & c_nand);
    assign out = ~combined_nand;
endmodule