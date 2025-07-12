module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized tree reduction functions
    function automatic logic tree_and;
        input [99:0] vec;
        integer i;
        begin
            tree_and = 1'b1;
            for (i = 0; i < 100; i = i + 1) begin
                if (!vec[i]) begin
                    tree_and = 1'b0;
                    break;  // Early termination
                end
            end
        end
    endfunction

    function automatic logic tree_or;
        input [99:0] vec;
        integer i;
        begin
            tree_or = 1'b0;
            for (i = 0; i < 100; i = i + 1) begin
                if (vec[i]) begin
                    tree_or = 1'b1;
                    break;  // Early termination
                end
            end
        end
    endfunction

    // Balanced XOR tree using recursive grouping
    function automatic logic tree_xor;
        input [99:0] vec;
        logic [49:0] stage1;
        logic [24:0] stage2;
        logic [12:0] stage3;
        logic [6:0] stage4;
        logic [3:0] stage5;
        logic [1:0] stage6;
        begin
            // First stage: 100 bits -> 50 bits
            for (integer i = 0; i < 50; i = i + 1)
                stage1[i] = vec[2*i] ^ vec[2*i+1];
            
            // Second stage: 50 bits -> 25 bits
            for (integer i = 0; i < 25; i = i + 1)
                stage2[i] = stage1[2*i] ^ stage1[2*i+1];
            
            // Third stage: 25 bits -> 13 bits
            for (integer i = 0; i < 12; i = i + 1)
                stage3[i] = stage2[2*i] ^ stage2[2*i+1];
            stage3[12] = stage2[24];
            
            // Continue reducing
            for (integer i = 0; i < 6; i = i + 1)
                stage4[i] = stage3[2*i] ^ stage3[2*i+1];
            stage4[6] = stage3[12];
            
            for (integer i = 0; i < 3; i = i + 1)
                stage5[i] = stage4[2*i] ^ stage4[2*i+1];
            stage5[3] = stage4[6];
            
            stage6[0] = stage5[0] ^ stage5[1];
            stage6[1] = stage5[2] ^ stage5[3];
            
            tree_xor = stage6[0] ^ stage6[1];
        end
    endfunction

    assign out_and = tree_and(in);
    assign out_or = tree_or(in);
    assign out_xor = tree_xor(in);

endmodule