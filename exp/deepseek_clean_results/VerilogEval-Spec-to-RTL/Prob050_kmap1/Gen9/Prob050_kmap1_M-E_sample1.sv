module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire a_n, b_n, c_n;
    wire nand_out;
    
    // Invert inputs
    assign a_n = ~a;
    assign b_n = ~b;
    assign c_n = ~c;
    
    // NAND of inverted inputs
    assign nand_out = ~(a_n & b_n & c_n);
    
    assign out = nand_out;
endmodule