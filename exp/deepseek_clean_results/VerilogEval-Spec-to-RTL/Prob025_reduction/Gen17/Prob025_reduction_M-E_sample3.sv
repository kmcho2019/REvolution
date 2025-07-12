module TopModule (
    input [7:0] in,
    output parity
);
    wire [3:0] stage1;
    wire [1:0] stage2;
    
    // First level of XOR (4 parallel XORs)
    assign stage1[0] = in[0] ^ in[1];
    assign stage1[1] = in[2] ^ in[3];
    assign stage1[2] = in[4] ^ in[5];
    assign stage1[3] = in[6] ^ in[7];
    
    // Second level of XOR (2 parallel XORs)
    assign stage2[0] = stage1[0] ^ stage1[1];
    assign stage2[1] = stage1[2] ^ stage1[3];
    
    // Final XOR
    assign parity = stage2[0] ^ stage2[1];
endmodule