module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Function to compute AND reduction using tree structure
    function automatic logic tree_and;
        input [99:0] vec;
        logic [63:0] stage1;
        logic [31:0] stage2;
        logic [15:0] stage3;
        logic [7:0]  stage4;
        logic [3:0]  stage5;
        logic [1:0]  stage6;
        begin
            // Stage 1: 100 -> 64
            for (int i = 0; i < 64; i++) begin
                stage1[i] = (i*2 < 100) ? vec[i*2] & ((i*2+1 < 100) ? vec[i*2+1] : 1'b1) : 1'b1;
            end
            
            // Stage 2: 64 -> 32
            for (int i = 0; i < 32; i++) begin
                stage2[i] = stage1[i*2] & stage1[i*2+1];
            end
            
            // Stage 3: 32 -> 16
            for (int i = 0; i < 16; i++) begin
                stage3[i] = stage2[i*2] & stage2[i*2+1];
            end
            
            // Stage 4: 16 -> 8
            for (int i = 0; i < 8; i++) begin
                stage4[i] = stage3[i*2] & stage3[i*2+1];
            end
            
            // Stage 5: 8 -> 4
            for (int i = 0; i < 4; i++) begin
                stage5[i] = stage4[i*2] & stage4[i*2+1];
            end
            
            // Stage 6: 4 -> 2
            for (int i = 0; i < 2; i++) begin
                stage6[i] = stage5[i*2] & stage5[i*2+1];
            end
            
            // Final AND
            tree_and = stage6[0] & stage6[1];
        end
    endfunction

    // Function to compute OR reduction using tree structure
    function automatic logic tree_or;
        input [99:0] vec;
        logic [63:0] stage1;
        logic [31:0] stage2;
        logic [15:0] stage3;
        logic [7:0]  stage4;
        logic [3:0]  stage5;
        logic [1:0]  stage6;
        begin
            // Stage 1: 100 -> 64
            for (int i = 0; i < 64; i++) begin
                stage1[i] = (i*2 < 100) ? vec[i*2] | ((i*2+1 < 100) ? vec[i*2+1] : 1'b0) : 1'b0;
            end
            
            // Stage 2: 64 -> 32
            for (int i = 0; i < 32; i++) begin
                stage2[i] = stage1[i*2] | stage1[i*2+1];
            end
            
            // Stage 3: 32 -> 16
            for (int i = 0; i < 16; i++) begin
                stage3[i] = stage2[i*2] | stage2[i*2+1];
            end
            
            // Stage 4: 16 -> 8
            for (int i = 0; i < 8; i++) begin
                stage4[i] = stage3[i*2] | stage3[i*2+1];
            end
            
            // Stage 5: 8 -> 4
            for (int i = 0; i < 4; i++) begin
                stage5[i] = stage4[i*2] | stage4[i*2+1];
            end
            
            // Stage 6: 4 -> 2
            for (int i = 0; i < 2; i++) begin
                stage6[i] = stage5[i*2] | stage5[i*2+1];
            end
            
            // Final OR
            tree_or = stage6[0] | stage6[1];
        end
    endfunction

    // Function to compute XOR reduction using tree structure
    function automatic logic tree_xor;
        input [99:0] vec;
        logic [63:0] stage1;
        logic [31:0] stage2;
        logic [15:0] stage3;
        logic [7:0]  stage4;
        logic [3:0]  stage5;
        logic [1:0]  stage6;
        begin
            // Stage 1: 100 -> 64
            for (int i = 0; i < 64; i++) begin
                stage1[i] = (i*2 < 100) ? vec[i*2] ^ ((i*2+1 < 100) ? vec[i*2+1] : 1'b0) : 1'b0;
            end
            
            // Stage 2: 64 -> 32
            for (int i = 0; i < 32; i++) begin
                stage2[i] = stage1[i*2] ^ stage1[i*2+1];
            end
            
            // Stage 3: 32 -> 16
            for (int i = 0; i < 16; i++) begin
                stage3[i] = stage2[i*2] ^ stage2[i*2+1];
            end
            
            // Stage 4: 16 -> 8
            for (int i = 0; i < 8; i++) begin
                stage4[i] = stage3[i*2] ^ stage3[i*2+1];
            end
            
            // Stage 5: 8 -> 4
            for (int i = 0; i < 4; i++) begin
                stage5[i] = stage4[i*2] ^ stage4[i*2+1];
            end
            
            // Stage 6: 4 -> 2
            for (int i = 0; i < 2; i++) begin
                stage6[i] = stage5[i*2] ^ stage5[i*2+1];
            end
            
            // Final XOR
            tree_xor = stage6[0] ^ stage6[1];
        end
    endfunction

    // Assign outputs using the tree functions
    assign out_and = tree_and(in);
    assign out_or  = tree_or(in);
    assign out_xor = tree_xor(in);

endmodule