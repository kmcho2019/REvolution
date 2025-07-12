module TopModule (
    input [7:0] in,
    output parity
);
    // First stage: XOR adjacent bits (4 parallel XORs)
    wire [3:0] stage1 = {
        in[7] ^ in[6],
        in[5] ^ in[4],
        in[3] ^ in[2],
        in[1] ^ in[0]
    };
    
    // Second stage: XOR stage1 results (2 parallel XORs)
    wire [1:0] stage2 = {
        stage1[3] ^ stage1[2],
        stage1[1] ^ stage1[0]
    };
    
    // Final XOR
    assign parity = stage2[1] ^ stage2[0];
endmodule