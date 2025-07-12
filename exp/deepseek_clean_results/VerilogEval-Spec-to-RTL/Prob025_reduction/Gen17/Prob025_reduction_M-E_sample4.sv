module TopModule (
    input [7:0] in,
    output parity
);
    wire stage1_0, stage1_1, stage1_2, stage1_3;
    wire stage2_0, stage2_1;
    wire stage3_0;
    
    // First stage - XOR adjacent bits
    assign stage1_0 = in[0] ^ in[1];
    assign stage1_1 = in[2] ^ in[3];
    assign stage1_2 = in[4] ^ in[5];
    assign stage1_3 = in[6] ^ in[7];
    
    // Second stage - combine first stage results
    assign stage2_0 = stage1_0 ^ stage1_1;
    assign stage2_1 = stage1_2 ^ stage1_3;
    
    // Final stage
    assign stage3_0 = stage2_0 ^ stage2_1;
    
    assign parity = stage3_0;
endmodule