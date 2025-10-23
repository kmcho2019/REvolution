module TopModule (
    input [7:0] in,
    output reg parity
);
    // Pipeline registers
    reg [3:0] stage1;
    reg [1:0] stage2;
    reg stage3;
    
    always @(*) begin
        // Stage 1: Pairwise XOR
        stage1[0] = in[0] ^ in[1];
        stage1[1] = in[2] ^ in[3];
        stage1[2] = in[4] ^ in[5];
        stage1[3] = in[6] ^ in[7];
        
        // Stage 2: Combine pairs
        stage2[0] = stage1[0] ^ stage1[1];
        stage2[1] = stage1[2] ^ stage1[3];
        
        // Stage 3: Final XOR
        stage3 = stage2[0] ^ stage2[1];
        
        // Output assignment
        parity = stage3;
    end
endmodule