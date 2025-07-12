module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Define the levels of the tree
    wire [127:0] level1 [7:0];
    wire [63:0] level2 [7:0];
    wire [31:0] level3 [7:0];
    wire [15:0] level4 [7:0];
    wire [7:0] level5 [7:0];
    wire [3:0] level6 [7:0];
    wire [1:0] level7 [7:0];
    wire level8;

    // First level: Divide 256 bits into 8 groups of 32 bits
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign level1[i] = in[(i*32)+31:(i*32)];
        end
    endgenerate

    // Second level: Divide each 32-bit group into 2 groups of 16 bits
    generate
        for (i = 0; i < 8; i++) begin
            assign level2[i] = (sel[7] == i[7]) ? level1[i][15:0] : level1[i][31:16];
        end
    endgenerate

    // Third level: Divide each 16-bit group into 2 groups of 8 bits
    generate
        for (i = 0; i < 8; i++) begin
            assign level3[i] = (sel[6] == i[6]) ? level2[i][7:0] : level2[i][15:8];
        end
    endgenerate

    // Fourth level: Divide each 8-bit group into 2 groups of 4 bits
    generate
        for (i = 0; i < 8; i++) begin
            assign level4[i] = (sel[5] == i[5]) ? level3[i][3:0] : level3[i][7:4];
        end
    endgenerate

    // Fifth level: Divide each 4-bit group into 2 groups of 2 bits
    generate
        for (i = 0; i < 8; i++) begin
            assign level5[i] = (sel[4] == i[4]) ? level4[i][1:0] : level4[i][3:2];
        end
    endgenerate

    // Sixth level: Divide each 2-bit group into 2 bits
    generate
        for (i = 0; i < 8; i++) begin
            assign level6[i] = (sel[3] == i[3]) ? level5[i][0] : level5[i][1];
        end
    endgenerate

    // Seventh level: Select the final bit
    generate
        for (i = 0; i < 8; i++) begin
            assign level7[i] = (sel[2] == i[2]) ? level6[i] : 1'b0;
        end
    endgenerate

    // Eighth level: Final selection
    assign level8 = (sel[1:0] == 2'b00) ? level7[0] :
                   (sel[1:0] == 2'b01) ? level7[1] :
                   (sel[1:0] == 2'b10) ? level7[2] :
                   (sel[1:0] == 2'b11) ? level7[3] : 1'b0;

    // Output the selected bit
    assign out = level8;

endmodule