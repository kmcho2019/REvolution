module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Level 7 (final selection)
    wire level7 = sel[7] ? in[255:128] : in[127:0];
    
    // Level 6
    wire [127:0] level6 = sel[6] ? level7[255:128] : level7[127:0];
    
    // Level 5
    wire [63:0] level5 = sel[5] ? level6[127:64] : level6[63:0];
    
    // Level 4
    wire [31:0] level4 = sel[4] ? level5[63:32] : level5[31:0];
    
    // Level 3
    wire [15:0] level3 = sel[3] ? level4[31:16] : level4[15:0];
    
    // Level 2
    wire [7:0] level2 = sel[2] ? level3[15:8] : level3[7:0];
    
    // Level 1
    wire [3:0] level1 = sel[1] ? level2[7:4] : level2[3:0];
    
    // Level 0 (final bit selection)
    assign out = sel[0] ? level1[3:2] : level1[1:0];
    assign out = sel[0] ? level1[1] : level1[0];

endmodule