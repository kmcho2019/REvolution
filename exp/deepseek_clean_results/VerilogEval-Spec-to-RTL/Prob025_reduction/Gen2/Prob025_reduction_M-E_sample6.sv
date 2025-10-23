module TopModule (
    input [7:0] in,
    output parity
);
    wire level1_0, level1_1, level1_2, level1_3;
    wire level2_0, level2_1;
    
    // First level XORs (parallel computation)
    assign level1_0 = in[0] ^ in[1];
    assign level1_1 = in[2] ^ in[3];
    assign level1_2 = in[4] ^ in[5];
    assign level1_3 = in[6] ^ in[7];
    
    // Second level XORs
    assign level2_0 = level1_0 ^ level1_1;
    assign level2_1 = level1_2 ^ level1_3;
    
    // Final XOR
    assign parity = level2_0 ^ level2_1;
endmodule