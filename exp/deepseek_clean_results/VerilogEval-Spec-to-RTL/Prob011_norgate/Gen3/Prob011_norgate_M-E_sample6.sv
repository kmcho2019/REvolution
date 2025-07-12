module TopModule (
    input a,
    input b,
    output out
);
    wire nand1_out, nand2_out;
    
    // First level NAND gates (inverters for inputs)
    assign nand1_out = ~(a & a);
    assign nand2_out = ~(b & b);
    
    // Second level NAND (OR equivalent)
    assign out = ~(nand1_out & nand2_out);
endmodule