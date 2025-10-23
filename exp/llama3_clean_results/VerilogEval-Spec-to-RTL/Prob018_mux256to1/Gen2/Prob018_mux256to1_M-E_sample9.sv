module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

    // Level 1: 2-to-1 multiplexers
    wire [127:0] out_level1;
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            assign out_level1[i] = (sel[0] == 0) ? in[i*2] : in[i*2 + 1];
        end
    endgenerate

    // Level 2: 2-to-1 multiplexers
    wire [63:0] out_level2;
    generate
        for (i = 0; i < 64; i++) begin
            assign out_level2[i] = (sel[1] == 0) ? out_level1[i*2] : out_level1[i*2 + 1];
        end
    endgenerate

    // Level 3: 2-to-1 multiplexers
    wire [31:0] out_level3;
    generate
        for (i = 0; i < 32; i++) begin
            assign out_level3[i] = (sel[2] == 0) ? out_level2[i*2] : out_level2[i*2 + 1];
        end
    endgenerate

    // Level 4: 2-to-1 multiplexers
    wire [15:0] out_level4;
    generate
        for (i = 0; i < 16; i++) begin
            assign out_level4[i] = (sel[3] == 0) ? out_level3[i*2] : out_level3[i*2 + 1];
        end
    endgenerate

    // Level 5: 2-to-1 multiplexers
    wire [7:0] out_level5;
    generate
        for (i = 0; i < 8; i++) begin
            assign out_level5[i] = (sel[4] == 0) ? out_level4[i*2] : out_level4[i*2 + 1];
        end
    endgenerate

    // Level 6: 2-to-1 multiplexers
    wire [3:0] out_level6;
    generate
        for (i = 0; i < 4; i++) begin
            assign out_level6[i] = (sel[5] == 0) ? out_level5[i*2] : out_level5[i*2 + 1];
        end
    endgenerate

    // Level 7: 2-to-1 multiplexers
    wire [1:0] out_level7;
    generate
        for (i = 0; i < 2; i++) begin
            assign out_level7[i] = (sel[6] == 0) ? out_level6[i*2] : out_level6[i*2 + 1];
        end
    endgenerate

    // Final level: 2-to-1 multiplexer
    wire out_level8;
    assign out_level8 = (sel[7] == 0) ? out_level7[0] : out_level7[1];

    // Output
    assign out = out_level8;

endmodule