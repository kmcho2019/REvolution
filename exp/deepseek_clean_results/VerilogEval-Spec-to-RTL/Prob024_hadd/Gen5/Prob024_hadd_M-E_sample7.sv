module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    wire nand1_out, nand2_out, nand3_out, nand4_out;
    
    // First level NAND gates
    assign nand1_out = ~(a & b);
    assign nand2_out = ~(a & nand1_out);
    assign nand3_out = ~(b & nand1_out);
    
    // Second level NAND for XOR (sum)
    assign nand4_out = ~(nand2_out & nand3_out);
    assign sum = nand4_out;
    
    // Carry-out is simply the NAND of inputs inverted
    assign cout = ~nand1_out;
endmodule