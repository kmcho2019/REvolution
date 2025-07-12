module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND tree
    wire [49:0] and_level1;
    wire [24:0] and_level2;
    wire [12:0] and_level3;
    wire [6:0]  and_level4;
    wire [3:0]  and_level5;
    wire [1:0]  and_level6;
    
    genvar i;
    generate
        // Level 1: 50 AND gates (100 inputs)
        for (i = 0; i < 50; i = i + 1) begin
            assign and_level1[i] = in[2*i] & in[2*i+1];
        end
        
        // Level 2: 25 AND gates (50 inputs)
        for (i = 0; i < 25; i = i + 1) begin
            assign and_level2[i] = and_level1[2*i] & and_level1[2*i+1];
        end
        
        // Level 3: 12 AND gates + propagate last (25 inputs)
        for (i = 0; i < 12; i = i + 1) begin
            assign and_level3[i] = and_level2[2*i] & and_level2[2*i+1];
        end
        assign and_level3[12] = and_level2[24];
        
        // Continue this pattern up to final level...
        // Level 4: 6 AND gates + propagate last (13 inputs)
        for (i = 0; i < 6; i = i + 1) begin
            assign and_level4[i] = and_level3[2*i] & and_level3[2*i+1];
        end
        assign and_level4[6] = and_level3[12];
        
        // Level 5: 3 AND gates + propagate last (7 inputs)
        for (i = 0; i < 3; i = i + 1) begin
            assign and_level5[i] = and_level4[2*i] & and_level4[2*i+1];
        end
        assign and_level5[3] = and_level4[6];
        
        // Level 6: 1 AND gate + propagate last (4 inputs)
        assign and_level6[0] = and_level5[0] & and_level5[1];
        assign and_level6[1] = and_level5[2] & and_level5[3];
        
        // Final AND
        assign out_and = and_level6[0] & and_level6[1];
    endgenerate

    // Similar tree structures for OR and XOR
    // OR tree (same structure as AND)
    wire [49:0] or_level1;
    wire [24:0] or_level2;
    wire [12:0] or_level3;
    wire [6:0]  or_level4;
    wire [3:0]  or_level5;
    wire [1:0]  or_level6;
    
    generate
        for (i = 0; i < 50; i = i + 1) begin
            assign or_level1[i] = in[2*i] | in[2*i+1];
        end
        for (i = 0; i < 25; i = i + 1) begin
            assign or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end
        for (i = 0; i < 12; i = i + 1) begin
            assign or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end
        assign or_level3[12] = or_level2[24];
        for (i = 0; i < 6; i = i + 1) begin
            assign or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end
        assign or_level4[6] = or_level3[12];
        for (i = 0; i < 3; i = i + 1) begin
            assign or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end
        assign or_level5[3] = or_level4[6];
        assign or_level6[0] = or_level5[0] | or_level5[1];
        assign or_level6[1] = or_level5[2] | or_level5[3];
        assign out_or = or_level6[0] | or_level6[1];
    endgenerate

    // XOR tree (same structure)
    wire [49:0] xor_level1;
    wire [24:0] xor_level2;
    wire [12:0] xor_level3;
    wire [6:0]  xor_level4;
    wire [3:0]  xor_level5;
    wire [1:0]  xor_level6;
    
    generate
        for (i = 0; i < 50; i = i + 1) begin
            assign xor_level1[i] = in[2*i] ^ in[2*i+1];
        end
        for (i = 0; i < 25; i = i + 1) begin
            assign xor_level2[i] = xor_level1[2*i] ^ xor_level1[2*i+1];
        end
        for (i = 0; i < 12; i = i + 1) begin
            assign xor_level3[i] = xor_level2[2*i] ^ xor_level2[2*i+1];
        end
        assign xor_level3[12] = xor_level2[24];
        for (i = 0; i < 6; i = i + 1) begin
            assign xor_level4[i] = xor_level3[2*i] ^ xor_level3[2*i+1];
        end
        assign xor_level4[6] = xor_level3[12];
        for (i = 0; i < 3; i = i + 1) begin
            assign xor_level5[i] = xor_level4[2*i] ^ xor_level4[2*i+1];
        end
        assign xor_level5[3] = xor_level4[6];
        assign xor_level6[0] = xor_level5[0] ^ xor_level5[1];
        assign xor_level6[1] = xor_level5[2] ^ xor_level5[3];
        assign out_xor = xor_level6[0] ^ xor_level6[1];
    endgenerate

endmodule