module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Optimal AND/OR implementations using reduction operators
    assign out_and = &in;
    assign out_or  = |in;
    
    // Parameterized logarithmic XOR tree implementation
    function automatic logic tree_xor(input [99:0] vec);
        integer i;
        logic [49:0] level1;
        logic [24:0] level2;
        logic [12:0] level3;
        logic [6:0] level4;
        logic [3:0] level5;
        logic [1:0] level6;
        
        // Level 1: 100 -> 50
        for (i = 0; i < 50; i = i + 1)
            level1[i] = vec[2*i] ^ vec[2*i+1];
            
        // Level 2: 50 -> 25
        for (i = 0; i < 25; i = i + 1)
            level2[i] = level1[2*i] ^ (2*i+1 < 50 ? level1[2*i+1] : 1'b0);
            
        // Level 3: 25 -> 13
        for (i = 0; i < 13; i = i + 1)
            level3[i] = level2[2*i] ^ (2*i+1 < 25 ? level2[2*i+1] : 1'b0);
            
        // Level 4: 13 -> 7
        for (i = 0; i < 7; i = i + 1)
            level4[i] = level3[2*i] ^ (2*i+1 < 13 ? level3[2*i+1] : 1'b0);
            
        // Level 5: 7 -> 4
        for (i = 0; i < 4; i = i + 1)
            level5[i] = level4[2*i] ^ (2*i+1 < 7 ? level4[2*i+1] : 1'b0);
            
        // Level 6: 4 -> 2
        for (i = 0; i < 2; i = i + 1)
            level6[i] = level5[2*i] ^ level5[2*i+1];
            
        // Final XOR
        tree_xor = level6[0] ^ level6[1];
    endfunction
    
    assign out_xor = tree_xor(in);

endmodule