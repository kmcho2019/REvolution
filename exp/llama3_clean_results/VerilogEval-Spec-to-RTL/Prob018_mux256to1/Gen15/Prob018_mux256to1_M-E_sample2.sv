module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Level 1: 128-to-1 selection
    wire [127:0] out_level1;
    assign out_level1 = (sel[7]) ? in[255:128] : in[127:0];

    // Level 2: 64-to-1 selection
    wire [63:0] out_level2;
    assign out_level2 = (sel[6]) ? out_level1[127:64] : out_level1[63:0];

    // Level 3: 32-to-1 selection
    wire [31:0] out_level3;
    assign out_level3 = (sel[5]) ? out_level2[63:32] : out_level2[31:0];

    // Level 4: 16-to-1 selection
    wire [15:0] out_level4;
    assign out_level4 = (sel[4]) ? out_level3[31:16] : out_level3[15:0];

    // Level 5: 8-to-1 selection
    wire [7:0] out_level5;
    assign out_level5 = (sel[3]) ? out_level4[15:8] : out_level4[7:0];

    // Level 6: 4-to-1 selection
    wire [3:0] out_level6;
    assign out_level6 = (sel[2]) ? out_level5[7:4] : out_level5[3:0];

    // Level 7: 2-to-1 selection
    wire [1:0] out_level7;
    assign out_level7 = (sel[1]) ? out_level6[3:2] : out_level6[1:0];

    // Final selection: 2-to-1
    assign out = (sel[0]) ? out_level7[1] : out_level7[0];

endmodule