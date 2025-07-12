module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire not_a, not_b, not_c;
    wire nand1, nand2;
    
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    
    assign nand1 = ~(not_a & not_b);
    assign nand2 = ~(nand1 & not_c);
    assign out = ~nand2;
endmodule