module TopModule (
    input [7:0] in,
    output parity
);
    wire [3:0] stage1;
    wire [1:0] stage2;
    wire stage3;
    
    // First stage: XOR pairs of bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE1
            assign stage1[i] = in[2*i] ^ in[2*i+1];
        end
    endgenerate
    
    // Second stage: XOR pairs of stage1 results
    generate
        for (i = 0; i < 2; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[2*i] ^ stage1[2*i+1];
        end
    endgenerate
    
    // Final stage: XOR the last two results
    assign stage3 = stage2[0] ^ stage2[1];
    
    assign parity = stage3;
endmodule