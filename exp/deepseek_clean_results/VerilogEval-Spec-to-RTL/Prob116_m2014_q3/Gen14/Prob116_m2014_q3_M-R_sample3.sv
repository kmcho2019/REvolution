module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // First level NAND gates
    wire nand1_out = ~(x[0] & x[2]);
    wire nand2_out = ~(x[0] & x[1] & x[3]);
    
    // Final NAND gate
    assign f = ~(nand1_out & nand2_out);
endmodule