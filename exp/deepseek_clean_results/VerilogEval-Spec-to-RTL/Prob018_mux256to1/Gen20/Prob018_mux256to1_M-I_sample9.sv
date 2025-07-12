module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Implement as balanced binary tree of 2:1 muxes
    wire [127:0] level1;
    wire [63:0]  level2;
    wire [31:0]  level3;
    wire [15:0]  level4;
    wire [7:0]   level5;
    wire [3:0]   level6;
    wire [1:0]   level7;
    
    // Level 1: 128 2:1 muxes
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : gen_level1
            assign level1[i] = sel[0] ? in[2*i+1] : in[2*i];
        end
        
        // Level 2: 64 2:1 muxes
        for (i = 0; i < 64; i = i + 1) begin : gen_level2
            assign level2[i] = sel[1] ? level1[2*i+1] : level1[2*i];
        end
        
        // Level 3: 32 2:1 muxes
        for (i = 0; i < 32; i = i + 1) begin : gen_level3
            assign level3[i] = sel[2] ? level2[2*i+1] : level2[2*i];
        end
        
        // Level 4: 16 2:1 muxes
        for (i = 0; i < 16; i = i + 1) begin : gen_level4
            assign level4[i] = sel[3] ? level3[2*i+1] : level3[2*i];
        end
        
        // Level 5: 8 2:1 muxes
        for (i = 0; i < 8; i = i + 1) begin : gen_level5
            assign level5[i] = sel[4] ? level4[2*i+1] : level4[2*i];
        end
        
        // Level 6: 4 2:1 muxes
        for (i = 0; i < 4; i = i + 1) begin : gen_level6
            assign level6[i] = sel[5] ? level5[2*i+1] : level5[2*i];
        end
        
        // Level 7: 2 2:1 muxes
        for (i = 0; i < 2; i = i + 1) begin : gen_level7
            assign level7[i] = sel[6] ? level6[2*i+1] : level6[2*i];
        end
        
        // Final level
        assign out = sel[7] ? level7[1] : level7[0];
    endgenerate
endmodule